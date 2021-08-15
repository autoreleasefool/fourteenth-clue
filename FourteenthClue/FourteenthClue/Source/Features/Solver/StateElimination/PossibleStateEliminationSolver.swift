//
//  PossibleStateEliminationSolver.swift
//  Fourteenth Clue
//
//  Created by Joseph Roque on 2021-07-04.
//

import Combine
import Foundation

class PossibleStateEliminationSolver: ClueSolver {

	private let subject: PassthroughSubject<[Solution], Never>

	private var possibleStatesCache: [PossibleState]?

	init() {
		let subject = PassthroughSubject<[Solution], Never>()
		self.subject = subject
		super.init(solutionsSubject: subject)
	}

	override func solve(state: GameState, prevState: GameState?) {
		let reporter = StepReporter(owner: self)
		guard state.id == self.state?.id else { return }

		let shouldCancelEarly = { [weak self] in
			state.id != self?.state?.id
		}

		if let prevState = prevState,
			 shouldClearStateCache(prevState: prevState, nextState: state) {
			possibleStatesCache = nil
		}

		reporter.reportStep(message: "Beginning state elimination")

		var states = possibleStatesCache ?? state.allPossibleStates(shouldCancel: shouldCancelEarly)
		reporter.reportStep(message: "Finished generating states")

		var clues = state.clues

		resolveMyAccusations(state, &clues, &states, shouldCancelEarly)
		reporter.reportStep(message: "Finished resolving my accusations")

		resolveOpponentAccusations(state, &clues, &states, shouldCancelEarly)
		reporter.reportStep(message: "Finished resolving opponent accusations")

		resolveInquisitionsInIsolation(state, &clues, &states, shouldCancelEarly)
		reporter.reportStep(message: "Finished resolving inquisitions in isolation")

		resolveInquisitionsInCombination(state, &clues, &states, shouldCancelEarly)
		reporter.reportStep(message: "Finished resolving inquisitions in combination")

		let solutions = processStatesIntoSolutions(states)
		guard state.id == self.state?.id else { return }

		reporter.reportStep(message: "Finished generating \(states.count) possible states.")
		possibleStatesCache = states
		subject.send(solutions.sorted().reversed())
	}

	private func resolveMyAccusations(
		_ state: GameState,
		_ clues: inout [AnyClue],
		_ possibleStates: inout [PossibleState],
		_ shouldCancelEarly: () -> Bool
	) {
		guard !shouldCancelEarly() else { return }

		let me = state.players.first!
		var cluesToRemove = IndexSet()

		clues.enumerated()
			// Filter out clues from opponents
			.filter { $0.element.primaryPlayer == me.id }
			// Only look at accusations
			.compactMap { offset, clue -> (Int, Accusation)? in
				guard let accusation = clue.wrappedValue as? Accusation else { return nil }
				return (offset, accusation)
			}
			.forEach { offset, accusation in
				// Remove state if the solution is identical to any accusation already made
				possibleStates.removeAll { $0.solution.cards == accusation.cards }
				// Filter out accusations since they're no longer useful
				cluesToRemove.insert(offset)
			}

		clues.remove(atOffsets: cluesToRemove)
	}

	private func resolveOpponentAccusations(
		_ state: GameState,
		_ clues: inout [AnyClue],
		_ possibleStates: inout [PossibleState],
		_ shouldCancelEarly: () -> Bool
	) {
		guard !shouldCancelEarly() else { return }

		let me = state.players.first!
		var cluesToRemove = IndexSet()

		clues.enumerated()
			// Filter out clues from me
			.filter { $0.element.primaryPlayer != me.id }
			// Only look at accusations
			.compactMap { offset, clue -> (Int, Accusation)? in
				guard let accusation = clue.wrappedValue as? Accusation else { return nil }
				return (offset, accusation)
			}
			.forEach { offset, accusation in
				guard !shouldCancelEarly() else { return }

				// Remove state if any cards in the accusation appear in the solution (opponents cannot guess cards they can see)
				possibleStates.removeAll { !$0.solution.cards.isDisjoint(with: accusation.cards) }

				// Filter out accusations since they're no longer useful
				cluesToRemove.insert(offset)
			}

		clues.remove(atOffsets: cluesToRemove)
	}

	private func resolveInquisitionsInCombination(
			_ state: GameState,
			_ clues: inout [AnyClue],
			_ possibleStates: inout [PossibleState],
			_ shouldCancelEarly: () -> Bool
		) {
			guard !shouldCancelEarly() else { return }
		}

	private func processStatesIntoSolutions(_ states: [PossibleState]) -> [Solution] {
		states.reduce(into: [Solution:Int]()) { counts, possibleState in
			counts[possibleState.solution] = (counts[possibleState.solution] ?? 0) + 1
		}.map { key, value in
			Solution(
				person: key.person,
				location: key.location,
				weapon: key.weapon,
				probability: Double(value) / Double(states.count)
			)
		}
	}

	private func shouldClearStateCache(prevState: GameState, nextState: GameState) -> Bool {
		!prevState.isEarlierState(of: nextState)
	}

}

// MARK: - Isolation rules

extension PossibleStateEliminationSolver {

	private func resolveInquisitionsInIsolation(
		_ state: GameState,
		_ clues: inout [AnyClue],
		_ possibleStates: inout [PossibleState],
		_ shouldCancelEarly: () -> Bool
	) {
		guard !shouldCancelEarly() else { return }

		let me = state.players.first!
		var cluesToRemove = IndexSet()

		clues.enumerated()
			// Filter out clues from me
			.filter { $0.element.primaryPlayer != me.id }
			// Only look at inquisitions (ignore accusations)
			.compactMap { offset, clue -> (Int, Inquisition)? in
				guard let inquisition = clue.wrappedValue as? Inquisition else { return nil }
				return (offset, inquisition)
			}
			.forEach { offset, inquisition in
				guard !shouldCancelEarly() else { return }

				applyRuleIfPlayerSeesNoneOfCategory(state, inquisition, &possibleStates)
				applyRuleIfPlayerSeesSomeOfCategory(state, inquisition, &possibleStates)
				applyRuleIfPlayerSeesAllOfCategory(state, inquisition, &possibleStates)
				applyRuleIfPlayerAsksAboutCategory(state, inquisition, &possibleStates)
			}

		clues.remove(atOffsets: cluesToRemove)
	}

	private func applyRuleIfPlayerSeesNoneOfCategory(
		_ state: GameState,
		_ inquisition: Inquisition,
		_ possibleStates: inout [PossibleState]
	) {
		guard inquisition.count == 0 else { return }

		let categoryCards = inquisition.cards.intersection(state.cards)

		// Remove states where any other player has said category in their mystery (would be visible to answering player)
		possibleStates.removeAll {
			$0.players
				.filter { $0.id != inquisition.answeringPlayer }
				.contains { !$0.mystery.cards.isDisjoint(with: categoryCards) }

		}

		// Remove states where answering player has said category in their hidden (would be visible to them)
		possibleStates.removeAll {
			$0.players
				.filter { $0.id == inquisition.answeringPlayer }
				.contains { !$0.hidden.cards.isDisjoint(with: categoryCards) }
		}
	}

	private func applyRuleIfPlayerSeesSomeOfCategory(
		_ state: GameState,
		_ inquisition: Inquisition,
		_ possibleStates: inout [PossibleState]
	) {
		let categoryCards = inquisition.cards.intersection(state.cards)
		let stateCardsMatchingCategory = state.cards.matching(filter: inquisition.filter)

		guard inquisition.count > 0 && inquisition.count < stateCardsMatchingCategory.count else { return }

		// Remove states where cards answering player can see does not equal their stated answer
		possibleStates.removeAll { possibleState in
			possibleState.players
				.filter { $0.id == inquisition.answeringPlayer }
				.contains { possibleState.cardsVisible(toPlayer: $0.id).intersection(categoryCards).count != inquisition.count }
		}
	}

	private func applyRuleIfPlayerSeesAllOfCategory(
		_ state: GameState,
		_ inquisition: Inquisition,
		_ possibleStates: inout [PossibleState]
	) {
		let categoryCards = inquisition.cards.intersection(state.cards)
		let stateCardsMatchingCategory = state.cards.matching(filter: inquisition.filter)

		guard inquisition.count == stateCardsMatchingCategory.count else { return }

		// Remove states where any other player has said category in their hidden (would not be visible to answering player)
		possibleStates.removeAll {
			$0.players
				.filter { $0.id != inquisition.answeringPlayer }
				.contains { !$0.hidden.cards.isDisjoint(with: categoryCards) }
		}

		// Remove states where answering player has said category in their mystery (would not be visible to them)
		possibleStates.removeAll {
			$0.players
				.filter { $0.id == inquisition.answeringPlayer }
				.contains { !$0.mystery.cards.isDisjoint(with: categoryCards) }
		}

		// Remove states where secret informants contain category (would not be visible to answering player)
		possibleStates.removeAll {
			!$0.informants.isDisjoint(with: categoryCards)
		}
	}

	private func applyRuleIfPlayerAsksAboutCategory(
		_ state: GameState,
		_ inquisition: Inquisition,
		_ possibleStates: inout [PossibleState]
	) {
		let categoryCards = inquisition.cards.intersection(state.cards)

		// Remove states where player can see all of the cards in the category
		possibleStates.removeAll { possibleState in
			possibleState.players
				.filter { $0.id == inquisition.askingPlayer }
				.contains { categoryCards.isSubset(of: possibleState.cardsVisible(toPlayer: $0.id)) }
		}
	}

}
