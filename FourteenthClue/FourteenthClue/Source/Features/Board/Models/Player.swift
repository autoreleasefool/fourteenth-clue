//
//  Player.swift
//  Fourteenth Clue
//
//  Created by Joseph Roque on 2021-06-27.
//

import Foundation

struct Player: Identifiable, Hashable {

	let id: String
	let name: String
	let privateCards: PrivateCardSet
	let mystery: MysteryCardSet

	static var `default`: Player {
		.init(name: "", privateCards: PrivateCardSet(), mystery: MysteryCardSet())
	}

	init(id: String? = nil, name: String, privateCards: PrivateCardSet, mystery: MysteryCardSet) {
		self.id = id ?? UUID().uuidString
		self.name = name
		self.privateCards = privateCards
		self.mystery = mystery
	}

	// MARK: Mutations

	func withId(_ newId: String) -> Player {
		.init(id: newId, name: name, privateCards: privateCards, mystery: mystery)
	}

	func withName(_ newName: String) -> Player {
		.init(id: id, name: newName, privateCards: privateCards, mystery: mystery)
	}

	func withPrivateCard(onLeft: Card? = nil) -> Player {
		.init(id: id, name: name, privateCards: privateCards.withCard(onLeft: onLeft), mystery: mystery)
	}

	func withPrivateCard(onRight: Card? = nil) -> Player {
		.init(id: id, name: name, privateCards: privateCards.withCard(onRight: onRight), mystery: mystery)
	}

	func withMysteryPerson(_ toCard: Card? = nil) -> Player {
		.init(id: id, name: name, privateCards: privateCards, mystery: mystery.withPerson(toCard))
	}

	func withMysteryLocation(_ toCard: Card? = nil) -> Player {
		.init(id: id, name: name, privateCards: privateCards, mystery: mystery.withLocation(toCard))
	}

	func withMysteryWeapon(_ toCard: Card? = nil) -> Player {
		.init(id: id, name: name, privateCards: privateCards, mystery: mystery.withWeapon(toCard))
	}

	// MARK: Properties

	var cards: Set<Card> {
		mystery.cards.union(privateCards.cards)
	}

}
