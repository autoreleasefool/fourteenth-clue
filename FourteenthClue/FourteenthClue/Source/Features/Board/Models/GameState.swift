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

	func updatePlayer(at index: Int, to player: Player) -> GameState {
		var updatedPlayers = players
		updatedPlayers[index] = player
		return .init(players: updatedPlayers, secretInformants: secretInformants, clues: clues, cards: cards)
	}

	func updateSecretInformant(at index: Int, to card: Card?) -> GameState {
		var updatedInformants = secretInformants
		updatedInformants[index] = card
		return .init(players: players, secretInformants: updatedInformants, clues: clues, cards: cards)
	}

	func addClue(_ clue: Clue) -> GameState {
		.init(players: players, secretInformants: secretInformants, clues: clues + [clue], cards: cards)
	}

	func removeClue(_ clue: Clue) -> GameState {
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

		func setName(to newName: String) -> Player {
			.init(name: newName, privateCards: privateCards, mystery: mystery)
		}

		func setPrivateCard(onLeft: Card? = nil) -> Player {
			.init(name: name, privateCards: privateCards.setCard(onLeft: onLeft), mystery: mystery)
		}

		func setPrivateCard(onRight: Card? = nil) -> Player {
			.init(name: name, privateCards: privateCards.setCard(onRight: onRight), mystery: mystery)
		}

		func setMysteryPerson(toCard: Card? = nil) -> Player {
			.init(name: name, privateCards: privateCards, mystery: mystery.setPerson(to: toCard))
		}

		func setMysteryLocation(toCard: Card? = nil) -> Player {
			.init(name: name, privateCards: privateCards, mystery: mystery.setLocation(to: toCard))
		}

		func setMysteryWeapon(toCard: Card? = nil) -> Player {
			.init(name: name, privateCards: privateCards, mystery: mystery.setWeapon(to: toCard))
		}
	}

}

// MARK: Player Cards

extension GameState.Player {

	struct PrivateCardSet {
		let leftCard: Card?
		let rightCard: Card?

		init(leftCard: Card? = nil, rightCard: Card? = nil) {
			self.leftCard = leftCard
			self.rightCard = rightCard
		}

		// MARK: Mutations

		func setCard(onLeft: Card?) -> PrivateCardSet {
			.init(leftCard: onLeft, rightCard: rightCard)
		}

		func setCard(onRight: Card?) -> PrivateCardSet {
			.init(leftCard: leftCard, rightCard: onRight)
		}
	}

	struct MysteryCardSet {
		let person: Card?
		let location: Card?
		let weapon: Card?

		init(person: Card? = nil, location: Card? = nil, weapon: Card? = nil) {
			assert(person == nil || person?.category == .person)
			assert(location == nil || location?.category == .location)
			assert(weapon == nil || weapon?.category == .weapon)

			self.person = person
			self.location = location
			self.weapon = weapon
		}

		// MARK: Mutations

		func setPerson(to newPerson: Card?) -> MysteryCardSet {
			.init(person: newPerson, location: location, weapon: weapon)
		}

		func setLocation(to newLocation: Card?) -> MysteryCardSet {
			.init(person: person, location: newLocation, weapon: weapon)
		}

		func setWeapon(to newWeapon: Card?) -> MysteryCardSet {
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
