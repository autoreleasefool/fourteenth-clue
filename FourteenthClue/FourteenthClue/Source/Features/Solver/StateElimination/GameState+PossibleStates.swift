//
//  GameState+PossibleStates.swift
//  GameState+PossibleStates
//
//  Created by Joseph Roque on 2021-08-02.
//

import Algorithms
import Foundation

extension GameState {

	func allPossibleStates() -> [PossibleState] {
		let me = players.first!
		let possibleSolutions = allPossibleSolutions()
		var possibleStates: [PossibleState] = []

		for solution in possibleSolutions {
			let mySolution = PossiblePlayer(
				mystery: PossibleMysterySet(solution),
				hidden: PossibleHiddenSet(me.privateCards)
			)

			let remainingCards = initialUnknownCards.subtracting(solution.cards)
			let cardPairs = Array(remainingCards.combinations(ofCount: 2))
				.map { Set($0) }

			GameState.generatePossibleStates(
				withBaseState: self,
				players: [mySolution],
				cardPairs: cardPairs,
				into: &possibleStates
			)
		}

		return possibleStates
	}

	private static func generatePossibleStates(
		withBaseState state: GameState,
		players: [PossiblePlayer],
		cardPairs: [Set<Card>],
		into possibleStates: inout [PossibleState]
	) {
		guard players.count < state.numberOfPlayers else {
			possibleStates.append(PossibleState(
				players: players,
				informants: Set(cardPairs.flatMap { $0 })
			))
			return
		}

		let nextPlayerIndex = players.count
		cardPairs.forEach { pair in
			let nextPlayer = PossiblePlayer(
				mystery: PossibleMysterySet(state.players[nextPlayerIndex].mystery),
				hidden: PossibleHiddenSet(pair)
			)

			GameState.generatePossibleStates(
				withBaseState: state,
				players: players + [nextPlayer],
				cardPairs: cardPairs.filter { $0.isDisjoint(with: pair) },
				into: &possibleStates
			)
		}
	}

}
