//
//  Clue.swift
//  Fourteenth Clue
//
//  Created by Joseph Roque on 2021-06-26.
//

import Foundation

struct Clue: Equatable, Identifiable {

	let id = UUID()
	let player: Int
	let detail: Detail
	let count: Int

	init(player: Int, detail: Detail, count: Int) {
		self.player = player
		self.detail = detail
		self.count = count
	}

}

extension Clue {

	enum Detail: Equatable, CustomStringConvertible {

		case color(Card.Color)
//		case men
//		case women
//		case


		var description: String {
			switch self {
			case .color(let color):
				return color.description
//			case .category(let category):
//				if
			}
		}

	}

}

// MARK: Strings

extension Clue {

	func description(withPlayer player: GameState.Player) -> String {
		"\(player.name) sees \(count) \(detail.description) cards"
	}
}
