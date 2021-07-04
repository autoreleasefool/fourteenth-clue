//
//  ClueSolver.swift
//  Fourteenth Clue
//
//  Created by Joseph Roque on 2021-06-22.
//

import Combine
import Foundation

class ClueSolver {

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

	private func solve(state: GameState) {
		var solutions = state.allPossibleSolutions
		var clues = state.clues
		removeImpossibleSolutions(state, &solutions)
		resolveCluesInIsolation(state, &clues, &solutions)
		resolveCluesInCombination(state, clues, &solutions)

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

	private func resolveCluesInIsolation(_ state: GameState, _ clues: inout [AnyClue], _ solutions: inout [Solution]) {
		let me = state.players.first!
		let cluesToRemove = IndexSet()

		clues
			.drop { $0.player == me.id }
			.enumerated()
			.forEach { index, clue in
				switch clue.wrappedValue {
				case let inq as Inquisition:
					guard inq.count > 0 else {
						solutions.removeAll { !$0.cards.isDisjoint(with: inq.cards) }
						return
					}
				case let acc as Accusation:
					break
				default:
					break
				}

				let mysteryCardsVisibleToMe = state.mysteryCardsVisibleToMe(excludingPlayer: clue.player)
				
			}
		

		clues.remove(atOffsets: cluesToRemove)
	}

	private func resolveCluesInCombination(_ state: GameState, _ clues: [Clue], _ solutions: inout [Solution]) {

	}

//	private func resolveClues(_ state: GameState, _ possibleCards: inout Set<Card>) {
//		let me = state.players.first!
//		let others = state.players.dropFirst()
//
//		let informants = Set(state.secretInformants.compactMap { $0.card })
//		let visibleToMe = state.cardsVisible(toPlayer: me)
//		let visibleToOthers: [UUID: Set<Card>] = others
//			.reduce(into: [UUID: Set<Card>]()) { visible, player in
//				visible[player.id] = state.cardsVisible(toPlayer: player)
//			}
//
//		for clue in state.clues.drop(while: { $0.player == me.id }) {
//			let visibleToPlayer = visibleToOthers[clue.player]!
//			let clueCards = Card.allCardsMatching(filter: clue.filter)
//				.intersection(state.allCards)
//
//
//		}
//	}

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
