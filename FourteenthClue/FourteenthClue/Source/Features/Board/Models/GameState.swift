//
//  GameState.swift
//  Fourteenth Clue
//
//  Created by Joseph Roque on 2021-06-23.
//

import SwiftUI

struct GameState {

	let players: [Player]
	let secretInformants: [Card?]
	let cards: CardSet
	let clues: [Clue]

	init(playerCount: Int) {
		self.players = (0..<playerCount).map { _ in .default }
		self.secretInformants = Array(repeating: nil, count: 8 - ((playerCount - 2) * 2))
		self.clues = []
		self.cards = CardSet(playerCount: playerCount)
	}

	private init(players: [Player], secretInformants: [Card?], clues: [Clue], cards: CardSet) {
		self.players = players
		self.secretInformants = secretInformants
		self.clues = clues
		self.cards = cards
	}

	// MARK: Mutations

	func withPlayer(_ player: Player, at index: Int) -> GameState {
		var updatedPlayers = players
		updatedPlayers[index] = player
		return .init(players: updatedPlayers, secretInformants: secretInformants, clues: clues, cards: cards)
	}

	func withSecretInformant(_ card: Card?, at index: Int) -> GameState {
		var updatedInformants = secretInformants
		updatedInformants[index] = card
		return .init(players: players, secretInformants: updatedInformants, clues: clues, cards: cards)
	}

	func addingClue(_ clue: Clue) -> GameState {
		.init(players: players, secretInformants: secretInformants, clues: clues + [clue], cards: cards)
	}

	func removingClue(_ clue: Clue) -> GameState {
		guard let clueIndex = self.clues.firstIndex(of: clue) else { return self }
		var clues = self.clues
		clues.remove(at: clueIndex)
		return .init(players: players, secretInformants: secretInformants, clues: clues, cards: cards)
	}

}

// MARK: Players

extension GameState {

	struct Player {
		let name: String
		let privateCards: PrivateCardSet
		let mystery: MysteryCardSet

		static var `default`: Player {
			.init(name: "", privateCards: PrivateCardSet(), mystery: MysteryCardSet())
		}

		init(name: String, privateCards: PrivateCardSet, mystery: MysteryCardSet) {
			self.name = name
			self.privateCards = privateCards
			self.mystery = mystery
		}

		// MARK: Mutations

		func withName(_ newName: String) -> Player {
			.init(name: newName, privateCards: privateCards, mystery: mystery)
		}

		func withPrivateCard(onLeft: Card? = nil) -> Player {
			.init(name: name, privateCards: privateCards.withCard(onLeft: onLeft), mystery: mystery)
		}

		func withPrivateCard(onRight: Card? = nil) -> Player {
			.init(name: name, privateCards: privateCards.withCard(onRight: onRight), mystery: mystery)
		}

		func withMysteryPerson(_ toCard: Card? = nil) -> Player {
			.init(name: name, privateCards: privateCards, mystery: mystery.withPerson(toCard))
		}

		func withMysteryLocation(_ toCard: Card? = nil) -> Player {
			.init(name: name, privateCards: privateCards, mystery: mystery.withLocation(toCard))
		}

		func withMysteryWeapon(_ toCard: Card? = nil) -> Player {
			.init(name: name, privateCards: privateCards, mystery: mystery.withWeapon(toCard))
		}
	}

}

// MARK: Player Cards

extension GameState {

	enum CardPosition: String, Identifiable {
		case leftCard
		case rightCard
		case person
		case location
		case weapon

		var categories: Set<Card.Category> {
			switch self {
			case .leftCard, .rightCard:
				return []
			case .person:
				return [.person(.man), .person(.woman)]
			case .location:
				return [.location(.indoors), .location(.outdoors)]
			case .weapon:
				return [.weapon(.melee), .weapon(.ranged)]
			}
		}

		var id: String {
			rawValue
		}
	}

}

extension GameState.Player {

	struct PrivateCardSet {
		let leftCard: Card?
		let rightCard: Card?

		init(leftCard: Card? = nil, rightCard: Card? = nil) {
			self.leftCard = leftCard
			self.rightCard = rightCard
		}

		// MARK: Mutations

		func withCard(onLeft: Card?) -> PrivateCardSet {
			.init(leftCard: onLeft, rightCard: rightCard)
		}

		func withCard(onRight: Card?) -> PrivateCardSet {
			.init(leftCard: leftCard, rightCard: onRight)
		}
	}

	struct MysteryCardSet {
		let person: Card?
		let location: Card?
		let weapon: Card?

		init(person: Card? = nil, location: Card? = nil, weapon: Card? = nil) {
			self.person = person
			self.location = location
			self.weapon = weapon
		}

		// MARK: Mutations

		func withPerson(_ newPerson: Card?) -> MysteryCardSet {
			.init(person: newPerson, location: location, weapon: weapon)
		}

		func withLocation(_ newLocation: Card?) -> MysteryCardSet {
			.init(person: person, location: newLocation, weapon: weapon)
		}

		func withWeapon(_ newWeapon: Card?) -> MysteryCardSet {
			.init(person: person, location: location, weapon: newWeapon)
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
