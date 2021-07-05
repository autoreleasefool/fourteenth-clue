//
//  SolutionEliminationSolver.swift
//  Fourteenth Clue
//
//  Created by Joseph Roque on 2021-07-04.
//

import Combine
import Foundation

class SolutionEliminationSolver: ClueSolver {

	var state: GameState? = nil {
		didSet {
			if isRunning {
				cancel()
			}

			if let state = state {
				startSolving(state: state)
			}
		}
	}

	private let queue = DispatchQueue(label: "ca.josephroque.FourteenthClue.Solver")

	private var currentWorkItem: DispatchWorkItem?
	private var isRunning: Bool {
		currentWorkItem?.isCancelled == false
	}

	private let solutionsSubject = PassthroughSubject<[Solution], Never>()
	var solutions: AnyPublisher<[Solution], Never> {
		solutionsSubject.eraseToAnyPublisher()
	}

	private func cancel() {
		solutionsSubject.send([])
		currentWorkItem?.cancel()
		currentWorkItem = nil
	}

	private func startSolving(state: GameState) {
		let workItem = DispatchWorkItem { [weak self] in
			self?.solve(state: state)
		}

		currentWorkItem = workItem
		queue.async(execute: workItem)
	}

	private var me: Player {
		state!.players.first!
	}

	private var others: ArraySlice<Player> {
		state!.players.dropFirst()
	}

	private func solve(state: GameState) {
		var solutions = state.allPossibleSolutions
		var clues = state.clues
		removeImpossibleSolutions(state, &solutions)
		resolveMyAccusations(state, &clues, &solutions)
		resolveOpponentAccusations(state, &clues, &solutions)
		resolveInquisitionsInIsolation(state, &clues, &solutions)
		resolveInquisitionsInCombination(state, &clues, &solutions)

		solutionsSubject.send(solutions)
	}

	private func removeImpossibleSolutions(_ state: GameState, _ solutions: inout [Solution]) {
		// Remove solutions with cards that other players have
		let allOthersCards = others.flatMap { $0.cards }
		solutions.removeAll { !$0.cards.isDisjoint(with: allOthersCards) }

		// Remove solutions with cards in my private cards
		solutions.removeAll { !$0.cards.isDisjoint(with: me.privateCards.cards) }

		// Remove solutions with secret informants
		solutions.removeAll { !$0.cards.isDisjoint(with: state.secretInformants.compactMap { $0.card })}

		// Remove any solutions that do not match confirmed cards
		me.mystery.cards.forEach { confirmedCard in
			solutions.removeAll { !$0.cards.contains(confirmedCard) }
		}
	}

	private func resolveMyAccusations(
		_ state: GameState,
		_ clues: inout [AnyClue],
		_ solutions: inout [Solution]
	) {
		var cluesToRemove = IndexSet()

		clues
			.enumerated()
			.drop { $0.element.player != me.id }
			.compactMap { offset, clue -> (Int, Accusation)? in
				guard let accusation = clue.wrappedValue as? Accusation else { return nil }
				return (offset, accusation)
			}
			.forEach { offset, accusation in
				// Remove solution if the accusation was already made (and was incorrect)
				solutions.removeAll { $0.cards == accusation.cards }
				cluesToRemove.insert(offset)
			}

		clues.remove(atOffsets: cluesToRemove)
	}

	private func resolveOpponentAccusations(
		_ state: GameState,
		_ clues: inout [AnyClue],
		_ solutions: inout [Solution]
	) {
		var cluesToRemove = IndexSet()

		clues
			.enumerated()
			.drop { $0.element.player == me.id }
			.compactMap { offset, clue -> (Int, Accusation)? in
				guard let accusation = clue.wrappedValue as? Accusation else { return nil }
				return (offset, accusation)
			}
			.forEach { offset, accusation in
				// Remove solution if any cards are in the accusation (opponents cannot guess cards they can see)
				solutions.removeAll { !$0.cards.isDisjoint(with: accusation.cards) }
				cluesToRemove.insert(offset)
			}

		clues.remove(atOffsets: cluesToRemove)
	}

	private func resolveInquisitionsInIsolation(
		_ state: GameState,
		_ clues: inout [AnyClue],
		_ solutions: inout [Solution]
	) {
		var cluesToRemove = IndexSet()

		clues
			.enumerated()
			.drop { $0.element.player == me.id }
			.compactMap { offset, clue -> (Int, Inquisition)? in
				guard let inquisition = clue.wrappedValue as? Inquisition else { return nil }
				return (offset, inquisition)
			}
			.forEach { offset, inquisition in
				guard inquisition.count > 0 else {
					solutions.removeAll { !$0.cards.isDisjoint(with: inquisition.cards) }
					cluesToRemove.insert(offset)
					return
				}

				let mysteryCardsVisibleToMe = state.mysteryCardsVisibleToMe(excludingPlayer: inquisition.player)
			}

		clues.remove(atOffsets: cluesToRemove)
	}

	private func resolveInquisitionsInCombination(
		_ state: GameState,
		_ clues: inout [AnyClue],
		_ solutions: inout [Solution]
	) {

	}

}

private extension GameState {

	var allPossibleSolutions: [Solution] {
		cards.people.flatMap { person in
			cards.locations.flatMap { location in
				cards.weapons.map { weapon in
					Solution(
						person: person,
						location: location,
						weapon: weapon,
						probability: 0
					)
				}
			}
		}
	}

}
