//
//  PossibleStateEliminationSolver.swift
//  Fourteenth Clue
//
//  Created by Joseph Roque on 2021-07-04.
//

import Algorithms
import Combine
import Foundation

class PossibleStateEliminationSolver: ClueSolver {

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

	var isEnabled: Bool = false {
		didSet {
			if isEnabled, let state = state {
				startSolving(state: state)
			} else if !isEnabled {
				cancel()
			}
		}
	}

	// MARK: Scheduling

	private let queue = DispatchQueue(label: "ca.josephroque.FourteenthClue.StateElimination")

	private var currentWorkItem: DispatchWorkItem?
	private var isRunning: Bool {
		currentWorkItem?.isCancelled == false
	}

	private let solutionsSubject = PassthroughSubject<[Solution], Never>()
	var solutions: AnyPublisher<[Solution], Never> {
		solutionsSubject.eraseToAnyPublisher()
	}

	func cancel() {
		solutionsSubject.send([])
		currentWorkItem?.cancel()
		currentWorkItem = nil
	}

	private func startSolving(state: GameState) {
		guard isEnabled else { return }

		let workItem = DispatchWorkItem { [weak self] in
			self?.solve(state: state)
		}

		currentWorkItem = workItem
		queue.async(execute: workItem)
	}

	// MARK: Solving

	private func solve(state: GameState) {
		var possibleStates = state.allPossibleStates()
		var clues = state.clues

		resolveMyAccusations(state, &clues, &possibleStates)
		resolveOpponentAccusations(state, &clues, &possibleStates)
		resolveInquisitionsInIsolation(state, &clues, &possibleStates)
		resolveInquisitionsInCombination(state, &clues, &possibleStates)
	}

	private func resolveMyAccusations(
		_ state: GameState,
		_ clues: inout [AnyClue],
		_ possibleStates: inout [PossibleState]
	) {
		let me = state.players.first!
		var cluesToRemove = IndexSet()

		clues.enumerated()
			// Filter out clues from opponents
			.filter { $0.element.player == me.id }
			// Only look at accusations
			.compactMap { offset, clue -> (Int, Accusation)? in
				guard let accusation = clue.wrappedValue as? Accusation else { return nil }
				return (offset, accusation)
			}
			.forEach { offset, accusation in
				// Remove state if the solution is identical to any accusation already made
				possibleStates.removeAll { $0.solution.cards == accusation.cards }
				cluesToRemove.insert(offset)
			}

		clues.remove(atOffsets: cluesToRemove)
	}

	private func resolveOpponentAccusations(
		_ state: GameState,
		_ clues: inout [AnyClue],
		_ possibleStates: inout [PossibleState]
	) {
		let me = state.players.first!
		var cluesToRemove = IndexSet()

		clues.enumerated()
			// Filter out clues from me
			.filter { $0.element.player != me.id }
			// Only look at accusations
			.compactMap { offset, clue -> (Int, Accusation)? in
				guard let accusation = clue.wrappedValue as? Accusation else { return nil }
				return (offset, accusation)
			}
			.forEach { offset, accusation in
				// Remove state if any cards in the accusation appear in the solution (opponents cannot guess cards they can see)
				possibleStates.removeAll { !$0.solution.cards.isDisjoint(with: accusation.cards) }
				cluesToRemove.insert(offset)
			}

		clues.remove(atOffsets: cluesToRemove)
	}

	private func resolveInquisitionsInIsolation(
		_ state: GameState,
		_ clues: inout [AnyClue],
		_ possibleStates: inout [PossibleState]
	) {
		let me = state.players.first!
		var cluesToRemove = IndexSet()

		clues.enumerated()
			// Filter out clues from me
			.filter { $0.element.player != me.id }
			// Only look at inquisitions (ignore accusations)
			.compactMap { offset, clue -> (Int, Inquisition)? in
				guard let inquisition = clue.wrappedValue as? Inquisition else { return nil }
				return (offset, inquisition)
			}
			.forEach { offset, inquisition in
				// If the player sees no cards of a category, we can remove all the cards
				// that belong to that category
				guard inquisition.count > 0 else {
					possibleStates.removeAll { !$0.solution.cards.isDisjoint(with: inquisition.cards) }
					cluesToRemove.insert(offset)
					return
				}

				let clueCards = inquisition.cards.intersection(state.cards)
				let numberOfCardsSeen = inquisition.count
				let cardsISeeThatPlayerSees = state.mysteryCardsVisibleToMe(excludingPlayer: inquisition.player)

//				if numberOfCardsSeen < mysteryCardsVisibleToMe.count {

			}


		clues.remove(atOffsets: cluesToRemove)
	}

	private func resolveInquisitionsInCombination(
		_ state: GameState,
		_ clues: inout [AnyClue],
		_ possibleStates: inout [PossibleState]
	) {
//		let me = state.players.first!
//		var cluesToRemove = IndexSet()
//
//		clues.enumerated()
//			// Filter out clues from me
//			.filter { $0.element.player != me.id }
//			// Only look at inquisitions (ignore accusations)
//			.compactMap { offset, clue -> (Int, Inquisition)? in
//				guard let inquisition = clue.wrappedValue as? Inquisition else { return nil }
//				return (offset, inquisition)
//			}
//			.forEach { offset, inquisition in
//
//			}
//
//		clues.remove(atOffsets: cluesToRemove)
	}
}

private extension GameState {

	func allPossibleStates() -> [PossibleState] {
		var possibleStates: [PossibleState] = []
		let unallocatedCards = self.unallocatedCards

		for me in allPossibleSolutions() {
			var remainingCards = unallocatedCards.subtracting(me.cards)
			let cardPairs = remainingCards.combinations(ofCount: 2)
			let possibleHiddenSets = Array(cardPairs).combinations(ofCount: numberOfPlayers - 1)

			for sets in Array(possibleHiddenSets).permutations() {
				for possibleHiddenSet in sets {
					let otherPlayers = possibleHiddenSet.enumerated().map { index, hiddenSet in
						return PossiblePlayer(
							id: players[index + 1].id,
							hidden: PossibleHiddenSet(hiddenSet),
							mystery: PossibleMysterySet(players[index + 1].mystery)
						)
					}

					remainingCards.subtract(otherPlayers.cards)

					possibleStates.append(PossibleState(
						players: [me] + otherPlayers,
						secretInformants: remainingCards
					))

					if possibleStates.count % 1_000_000 == 0 {
						print("States so far: \(possibleStates.count)")
					}
				}
			}
		}

		return possibleStates
	}

	/// Returns all combinations of person/location/weapon with cards that have not already been
	/// assigned a position in the state. If the first player has any cards specified, they are used
	/// instead of the full set of unassigned cards
	func allPossibleSolutions() -> [PossiblePlayer] {
		let unallocatedCards = self.unallocatedCards
		let me = players.first!
		let myBaseSet = me.mystery

		let people, locations, weapons: Set<Card>

		if let person = myBaseSet.person {
			people = Set([person])
		} else {
			people = unallocatedCards.people
		}

		if let location = myBaseSet.location {
			locations = Set([location])
		} else {
			locations = unallocatedCards.locations
		}

		if let weapon = myBaseSet.weapon {
			weapons = Set([weapon])
		} else {
			weapons = unallocatedCards.weapons
		}

		return people.flatMap { person in
			locations.flatMap { location in
				weapons.map { weapon in
					PossiblePlayer(
						id: me.id,
						hidden: PossibleHiddenSet(me.privateCards),
						mystery: PossibleMysterySet(person: person, location: location, weapon: weapon)
					)
				}
			}
		}
	}

}
