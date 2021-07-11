//
//  PossibleState.swift
//  Fourteenth Clue
//
//  Created by Joseph Roque on 2021-07-10.
//

import Foundation

struct PossibleState {
	let players: [PossiblePlayer]
	let secretInformants: Set<Card>
}

struct PossiblePlayer {
	let id: String
	let hidden: PossibleHiddenSet
	let mystery: PossibleMysterySet

	var cards: Set<Card> {
		hidden.cards.union(mystery.cards)
	}
}

struct PossibleHiddenSet {
	let leftCard: Card
	let rightCard: Card

	init(_ leftCard: Card, _ rightCard: Card) {
		self.leftCard = leftCard
		self.rightCard = rightCard
	}

	init<C: Collection>(_ cards: C) where C.Element == Card {
		self.leftCard = cards.first!
		self.rightCard = cards.dropFirst().first!
	}

	init(_ privateCards: PrivateCardSet) {
		self.leftCard = privateCards.leftCard!
		self.rightCard = privateCards.rightCard!
	}

	var cards: Set<Card> {
		[leftCard, rightCard]
	}
}

struct PossibleMysterySet {
	let person: Card
	let location: Card
	let weapon: Card

	init(person: Card, location: Card, weapon: Card) {
		self.person = person
		self.location = location
		self.weapon = weapon
	}

	init(_ mystery: MysteryCardSet) {
		self.person = mystery.person!
		self.location = mystery.location!
		self.weapon = mystery.weapon!
	}

	var cards: Set<Card> {
		[person, location, weapon]
	}
}

extension Collection where Element == PossiblePlayer {

	var cards: Set<Card> {
		reduce(into: Set<Card>()) { result, player in
			result.formUnion(player.cards)
		}
	}

}
