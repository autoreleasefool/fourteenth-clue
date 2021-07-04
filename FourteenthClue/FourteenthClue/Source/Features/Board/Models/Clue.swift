//
//  Clue.swift
//  Fourteenth Clue
//
//  Created by Joseph Roque on 2021-06-27.
//

import Foundation

struct Clue: Equatable, Identifiable {

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

}

extension Clue {

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

// MARK: Strings

extension Clue {

	func description(withPlayer player: Player?) -> String {
		"\(player?.name ?? "Somebody") sees \(count) \(filter.description) cards"
	}

}
