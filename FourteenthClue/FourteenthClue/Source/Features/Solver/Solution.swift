//
//  Solution.swift
//  Fourteenth Clue
//
//  Created by Joseph Roque on 2021-06-28.
//

import Foundation

struct Solution: Equatable, Comparable, Identifiable, Hashable {

	let person: Card
	let location: Card
	let weapon: Card

	let probability: Double

	var id: String {
		"\(person)/\(location)/\(weapon)"
	}

	var cards: Set<Card> {
		[person, location, weapon]
	}

	init(person: Card, location: Card, weapon: Card, probability: Double = 0) {
		self.person = person
		self.location = location
		self.weapon = weapon
		self.probability = probability
	}

	init(_ mystery: PossibleMysterySet) {
		self.person = mystery.person
		self.location = mystery.location
		self.weapon = mystery.weapon
		self.probability = 0
	}

	static func < (lhs: Solution, rhs: Solution) -> Bool {
		(lhs.probability, lhs.person, lhs.location, lhs.weapon) <
			(rhs.probability, rhs.person, rhs.location, rhs.weapon)
	}

}
