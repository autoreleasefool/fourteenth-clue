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

	var solution: Solution {
		Solution(players.first!.mystery)
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

	init(_ solution: Solution) {
		self.person = solution.person
		self.location = solution.location
		self.weapon = solution.weapon
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

	init<C: Collection>(_ cards: C) where C.Element == Card {
		self.left = cards.first!
		self.right = cards.dropFirst().first!
	}

	var cards: Set<Card> {
		[left, right]
	}
}
