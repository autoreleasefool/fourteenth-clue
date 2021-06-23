//
//  GameState.swift
//  Fourteenth Clue
//
//  Created by Joseph Roque on 2021-06-23.
//

import SwiftUI

struct GameState {

	var players: [Player]
	var secretInformants: [Card?]
	var cards: CardSet

	init(playerCount: Int) {
		self.players = (0..<playerCount).map { Player(name: "Player \($0 + 1)") }
		self.secretInformants = Array(repeating: nil, count: 8 - ((playerCount - 2) * 2))
		self.cards = CardSet(playerCount: playerCount)
	}

}

// MARK: Players

extension GameState {

	struct Player {
		var name: String
		var privateCards = PrivateCardSet()
		var mystery = MysteryCardSet()
	}

}

// MARK: Player Cards

extension GameState.Player {

	struct PrivateCardSet {
		var leftCard: Card?
		var rightCard: Card?
	}

	struct MysteryCardSet {
		var person: Card?
		var location: Card?
		var weapon: Card?

		init(person: Card? = nil, location: Card? = nil, weapon: Card? = nil) {
			assert(person == nil || person?.category == .person)
			assert(location == nil || location?.category == .location)
			assert(weapon == nil || weapon?.category == .weapon)

			self.person = person
			self.location = location
			self.weapon = weapon
		}
	}

}

// MARK: Card set

extension GameState {

	struct CardSet {
		let cards: Set<Card>

		init(playerCount: Int) {
			var availableCards = Set(Card.allCases)
			switch playerCount {
			case 2:
				availableCards = availableCards.subtracting(Card.orangeCards)
				fallthrough
			case 3:
				availableCards = availableCards.subtracting(Card.whiteCards)
				fallthrough
			case 4:
				availableCards = availableCards.subtracting(Card.brownCards)
				fallthrough
			case 5:
				availableCards = availableCards.subtracting(Card.grayCards)
			default:
				break
			}

			self.cards = availableCards
		}

		// MARK: Colors

		var purpleCards: Set<Card> { cards.intersection(Card.purpleCards) }
		var pinkCards: Set<Card> { cards.intersection(Card.pinkCards) }
		var redCards: Set<Card> { cards.intersection(Card.redCards) }
		var greenCards: Set<Card> { cards.intersection(Card.greenCards) }
		var yellowCards: Set<Card> { cards.intersection(Card.yellowCards) }
		var blueCards: Set<Card> { cards.intersection(Card.blueCards) }
		var orangeCards: Set<Card> { cards.intersection(Card.orangeCards) }
		var whiteCards: Set<Card> { cards.intersection(Card.whiteCards) }
		var brownCards: Set<Card> { cards.intersection(Card.brownCards) }
		var grayCards: Set<Card> { cards.intersection(Card.grayCards) }

		// MARK: People

		var peopleCards: Set<Card> { cards.intersection(Card.peopleCards) }
		var menCards: Set<Card> { cards.intersection(Card.menCards) }
		var womenCards: Set<Card> { cards.intersection(Card.womenCards) }

		// MARK: Locations

		var locationsCards: Set<Card> { cards.intersection(Card.locationsCards) }
		var outdoorsCards: Set<Card> { cards.intersection(Card.outdoorsCards) }
		var indoorsCards: Set<Card> { cards.intersection(Card.indoorsCards) }

		// MARK: Weapons

		var weaponsCards: Set<Card> { cards.intersection(Card.weaponsCards) }
		var rangedCards: Set<Card> { cards.intersection(Card.rangedCards) }
		var meleeCards: Set<Card> { cards.intersection(Card.meleeCards) }

	}

}
