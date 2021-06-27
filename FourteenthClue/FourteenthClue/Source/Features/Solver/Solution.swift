//
//  Solution.swift
//  Fourteenth Clue
//
//  Created by Joseph Roque on 2021-06-22.
//

import Foundation

struct Solution {

	let players: [Player]
	let secretInformants: [Card: Double]

	init(playerCount: Int) {
		self.players = (0..<playerCount).map { _ in
			Player(privateCards: PrivateCardSet.allCards, mystery: MysteryCardSet.allCards)
		}

		self.secretInformants = equalProbability(forAllCards: Card.allCases)
	}

}

// MARK: Players

extension Solution {

	struct Player {
		let privateCards: PrivateCardSet
		let mystery: MysteryCardSet
	}

}

// MARK: Cards

extension Solution {

	struct PrivateCardSet {
		let leftCard: [Card: Double]
		let rightCard: [Card: Double]

		static var allCards: PrivateCardSet {
			PrivateCardSet(
				leftCard: equalProbability(forAllCards: Card.allCases),
				rightCard: equalProbability(forAllCards: Card.allCases)
			)
		}
	}

	struct MysteryCardSet {
		let person: [Card: Double]
		let location: [Card: Double]
		let weapon: [Card: Double]

		init(person: [Card: Double], location: [Card: Double], weapon: [Card: Double]) {
			self.person = person
			self.location = location
			self.weapon = weapon
		}

		static var allCards: MysteryCardSet {
			MysteryCardSet(
				person: equalProbability(forAllCards: Card.peopleCards),
				location: equalProbability(forAllCards: Card.locationsCards),
				weapon: equalProbability(forAllCards: Card.weaponsCards)
			)
		}
	}

}

// MARK: Probability

private func equalProbability<C: Collection>(
	forAllCards cards: C
) -> [Card: Double] where C.Element == Card {
	cards.reduce(into: [Card: Double]()) { result, card in
		result[card] = 100.0 / Double(cards.count)
	}
}
