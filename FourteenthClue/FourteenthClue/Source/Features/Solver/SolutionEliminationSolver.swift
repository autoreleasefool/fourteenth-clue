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

	var isEnabled: Bool = false {
		didSet {
			if !isEnabled {
				cancel()
			}
		}
	}

	private let queue = DispatchQueue(label: "ca.josephroque.FourteenthClue.SolutionElimination")

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
		let me = state.players.first!
		let others = state.players.dropFirst()

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
		let me = state.players.first!
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
		let me = state.players.first!
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
		let me = state.players.first!
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
//
//var initialGameStateForCopy = null;
//var orig = gameui.notif_onCombinaisonAssigned;
//gameui.notif_onCombinaisonAssigned = function (e) {
//		try {
//				console.log(e.args.visible_cards_players);
//				initialGameStateForCopy = JSON.stringify(e.args.visible_cards_players);
//				console.log(initialGameStateForCopy)
//				orig.call(this, e);
//		} catch (e) {
//				console.log("joseph" + e);
//		}
//}
//
//

//[Log] {"83959368":[{"name":"Park","type":"Location","subtype":"Outdoor","color":"Green","id":"3","type_arg":"14"},{"name":"Candlestick","type":"Weapon","subtype":"Up Close","color":"White","id":"14","type_arg":"28"},{"name":"Maid","type":"Person","subtype":"Female","color":"Blue","id":"18","type_arg":"6"}],"85268622":[{"name":"Officer","type":"Person","subtype":"Male","color":"Purple","id":"9","type_arg":"1"},{"name":"Sword","type":"Weapon","subtype":"Up Close","color":"Green","id":"12","type_arg":"24"},{"name":"Market","type":"Location","subtype":"Outdoor","color":"Pink","id":"16","type_arg":"12"}],"87792535":[{"name":"Duke","type":"Person","subtype":"Male","color":"Pink","id":"5","type_arg":"2"},{"name":"Harbor","type":"Location","subtype":"Outdoor","color":"Blue","id":"8","type_arg":"16"},{"name":"Blowgun","type":"Weapon","subtype":"Ranged","color":"Yellow","id":"10","type_arg":"25"}],"88584546":[{"name":"Butcher","type":"Person","subtype":"Male","color":"Red","id":"2","type_arg":"3"},{"name":"Dancer","type":"Person","subtype":"Female","color":"Orange","id":"7","type_arg":"7"}]}