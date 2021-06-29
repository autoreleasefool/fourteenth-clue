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
		let me = state.players.first!

		var possibleCards = state.cards
		removeObviousCards(state, &possibleCards)
		resolveClues(state, &possibleCards)

		buildSolutions(from: possibleCards)
	}

	private func removeObviousCards(_ state: GameState, _ possibleCards: inout Set<Card>) {
		let me = state.players.first!
		let others = state.players.dropFirst()

		// Remove cards that other players have
		possibleCards.subtract(others.flatMap { $0.cards })

		// Remove my private cards
		possibleCards.subtract(me.privateCards.cards)

		// Remove secret informants
		possibleCards.subtract(state.secretInformants.compactMap { $0.card })

		// Remove any cards that are the same type as one I have already confirmed
		me.mystery.cards.forEach { confirmedCard in
			possibleCards.subtract(
				Card
					.allCardsMatching(category: confirmedCard.category)
					.subtracting([confirmedCard])
			)
		}
	}

	private func resolveClues(_ state: GameState, _ possibleCards: inout Set<Card>) {
		let me = state.players.first!
		let others = state.players.dropFirst()

		let informants = Set(state.secretInformants.compactMap { $0.card })
		let visibleToMe = state.cardsVisible(toPlayer: me)
		let visibleToOthers: [UUID: Set<Card>] = others
			.reduce(into: [UUID: Set<Card>]()) { visible, player in
				visible[player.id] = state.cardsVisible(toPlayer: player)
			}

		for clue in state.clues.drop(while: { $0.player == me.id }) {
			let visibleToPlayer = visibleToOthers[clue.player]!
			let clueCards = Card.allCardsMatching(filter: clue.filter)
				.intersection(state.allCards)


		}
	}

	private func buildSolutions(from possibleCards: Set<Card>) {
		let people = possibleCards.people
		let locations = possibleCards.locations
		let weapons = possibleCards.weapons

		var solutions: [Solution] = []
		for person in people {
			for location in locations {
				for weapon in weapons {
					solutions.append(Solution(
						person: person,
						location: location,
						weapon: weapon,
						probability: 0
					))
				}
			}
		}

		solutionsSubject.send(solutions.sorted())
	}

}
