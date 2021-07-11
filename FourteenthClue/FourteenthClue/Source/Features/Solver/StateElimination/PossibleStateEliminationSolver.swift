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
		var states = state.allPossibleStates()
		print("Total states: \(states.count)")
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

			for possibleHiddenSet in possibleHiddenSets {
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
