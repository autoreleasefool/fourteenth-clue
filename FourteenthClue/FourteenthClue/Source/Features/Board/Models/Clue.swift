//
//  Clue.swift
//  Fourteenth Clue
//
//  Created by Joseph Roque on 2021-06-27.
//

import Foundation

protocol Clue {
	var id: UUID { get }
	var primaryPlayer: String { get }
	var cards: Set<Card> { get }

	func description(withPlayers players: [Player]) -> String
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
	var primaryPlayer: String { wrappedValue.primaryPlayer }
	var cards: Set<Card> { wrappedValue.cards }

	init(_ clue: Clue) {
		self.wrappedValue = clue
	}

	func description(withPlayers players: [Player]) -> String {
		wrappedValue.description(withPlayers: players)
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
	let askingPlayer: String
	let answeringPlayer: String
	let filter: Filter
	let count: Int

	init(askingPlayer: String, answeringPlayer: String, filter: Filter, count: Int) {
		self.askingPlayer = askingPlayer
		self.answeringPlayer = answeringPlayer
		self.filter = filter
		self.count = count
	}

	var cards: Set<Card> {
		Card.allCardsMatching(filter: filter)
	}

	var primaryPlayer: String {
		answeringPlayer
	}

	func description(withPlayers players: [Player]) -> String {
		let askingPlayer = players.first(where: { $0.id == self.askingPlayer })!
		let answeringPlayer = players.first(where: { $0.id == self.answeringPlayer })!
		return "\(askingPlayer.name) asks \(answeringPlayer.name), they see \(count) \(filter.description)"
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

		static func == (lhs: Filter, rhs: Inquiry.Category) -> Bool {
			switch (lhs, rhs) {
			case (.category(let left), .category(let right)):
				return left == right
			case (.color(let left), .color(let right)):
				return left == right
			case (.category, _), (.color, _):
				return false
			}
		}

	}

}

// MARK: - Accusation

struct Accusation: Clue, Equatable {

	let id = UUID()
	let accusingPlayer: String
	let accusation: MysteryCardSet

	var cards: Set<Card> {
		accusation.cards
	}

	var primaryPlayer: String {
		accusingPlayer
	}

	init(accusingPlayer: String, accusation: MysteryCardSet) {
		self.accusingPlayer = accusingPlayer
		self.accusation = accusation
	}

	func description(withPlayers players: [Player]) -> String {
		guard let person = accusation.person,
					let location = accusation.location,
					let weapon = accusation.weapon,
					let player = players.first(where: { $0.id == self.primaryPlayer }) else { return "Invalid accusation" }
		return "\(player.name) has made an accusation: \(person.rawValue.capitalized), \(location.rawValue.capitalized), \(weapon.rawValue.capitalized)"
	}

}
