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
		let others = Array(players.dropFirst())

		let possibleCards = self.initialUnknownCards
		let possibleSolutions = allPossibleSolutions()

		for solution in possibleSolutions {
			let remainingCards = initialUnknownCards.subtracting(solution.cards)
			let cardPairs = Array(remainingCards.combinations(ofCount: 2))
			print(cardPairs.count)
		}

//		return possibleSolutions.flatMap { solution in
//			let remainingCards = cardsForSolutions.subtracting(solution.cards)
//			let cardPairs = Array(cards.combinations(ofCount: 2))
//			print(cardPairs.count)
//
//			return []
//		}
		return []
	}

}
