//
//  Clue.swift
//  Fourteenth Clue
//
//  Created by Joseph Roque on 2021-06-27.
//

import Foundation

protocol Clue {
	var id: UUID { get }
	var player: UUID { get }
	var cards: Set<Card> { get }

	func description(withPlayer player: Player?) -> String
	func isEqual(to other: Clue) -> Bool
}

extension Clue where Self: Equatable {

	func isEqual(to other: Clue) -> Bool {
		guard let other = other as? Self else { return false }
		return self == other
	}

}

// MARK: - AnyClue

struct AnyClue: Clue, Identifiable {

	let wrappedValue: Clue

	var id: UUID { wrappedValue.id }
	var player: UUID { wrappedValue.player }
	var cards: Set<Card> { wrappedValue.cards }

	init(_ clue: Clue) {
		self.wrappedValue = clue
	}

	func description(withPlayer player: Player?) -> String {
		wrappedValue.description(withPlayer: player)
	}

}

extension AnyClue: Equatable {

	static func == (lhs: AnyClue, rhs: AnyClue) -> Bool {
		return lhs.wrappedValue.isEqual(to: rhs.wrappedValue)
	}

}

// MARK: - Inquisition

struct Inquisition: Clue, Equatable {

	let id = UUID()
	let player: UUID
	let filter: Filter
	let count: Int

	init(player: UUID, filter: Filter, count: Int) {
		self.player = player
		self.filter = filter
		self.count = count
	}

	var cards: Set<Card> {
		Card.allCardsMatching(filter: filter)
	}

	func description(withPlayer player: Player?) -> String {
		"\(player?.name ?? "Somebody") sees \(count) \(filter.description) cards"
	}

}

extension Inquisition {

	enum Filter: Equatable, CustomStringConvertible {
		case color(Card.Color)
		case category(Card.Category)

		var description: String {
			switch self {
			case .color(let color):
				return color.description
			case .category(let category):
				return category.description
			}
		}

	}

}

// MARK: - Accusation

struct Accusation: Clue, Equatable {

	let id = UUID()
	let player: UUID
	let accusation: MysteryCardSet

	var cards: Set<Card> {
		accusation.cards
	}

	init(player: UUID, accusation: MysteryCardSet) {
		self.player = player
		self.accusation = accusation
	}

	func description(withPlayer player: Player?) -> String {
		guard let person = accusation.person,
					let location = accusation.location,
					let weapon = accusation.weapon else { return "Invalid accusation" }
		return "\(player?.name ?? "Somebody") has made an accusation: \(person.rawValue.capitalized), \(location.rawValue.capitalized), \(weapon.rawValue.capitalized)"
	}

}
