//
//  PossibleState.swift
//  PossibleState
//
//  Created by Joseph Roque on 2021-08-02.
//

import Foundation

struct PossibleState {
	let players: [PossiblePlayer]
	let informants: Set<Card>

	var solution: PossibleMysterySet {
		players.first!.mystery
	}
}

struct PossiblePlayer {
	let mystery: PossibleMysterySet
	let hidden: PossibleHiddenSet
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

struct PossibleHiddenSet {
	let left: Card
	let right: Card

	init(left: Card, right: Card) {
		self.left = left
		self.right = right
	}

	init(_ hidden: PrivateCardSet) {
		self.left = hidden.leftCard!
		self.right = hidden.rightCard!
	}

	var cards: Set<Card> {
		[left, right]
	}
}
