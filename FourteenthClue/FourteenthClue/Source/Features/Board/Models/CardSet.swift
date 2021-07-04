//
//  CardSet.swift
//  Fourteenth Clue
//
//  Created by Joseph Roque on 2021-06-27.
//

import Foundation

struct PrivateCardSet: Hashable {

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

	// MARK: Properties

	var cards: Set<Card> {
		Set([leftCard, rightCard].compactMap { $0 })
	}

}

struct MysteryCardSet: Hashable {

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

	// MARK: Properties

	var cards: Set<Card> {
		Set([person, location, weapon].compactMap { $0 })
	}

}

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
