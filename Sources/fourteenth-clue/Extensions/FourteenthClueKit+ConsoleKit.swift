//
//  FourteenthClueKit+ConsoleKit.swift
//  FourteenthClue
//
//  Created by Joseph Roque on 2021-08-20.
//

import ConsoleKit
import FourteenthClueKit

extension String {

	func consoleText(withState state: GameState) -> [ConsoleTextFragment] {
		Array(self
			.components(separatedBy: " ")
			.map { string -> ConsoleTextFragment in
				if let category = Card.Category(rawValue: string.lowercased()) {
					return category.asConsoleText
				} else if let color = Card.Color(rawValue: string.lowercased()) {
					return color.asConsoleText
				} else if let card = Card(rawValue: string.lowercased()) {
					return card.asConsoleText
				} else if state.players.contains(where: { $0.name == string }) {
					return string.highlighted
				}

				return .init(string: string)
			}
			.flatMap { [$0, .init(string: " ")] }
			.dropLast()
		)
	}

	var highlighted: ConsoleTextFragment {
		.init(string: self, style: .init(color: .custom(r: 150, g: 255, b: 130)))
	}

}

extension Card {

	var asConsoleText: ConsoleTextFragment {
		.init(string: name.capitalized, style: .init(color: color.consoleTextColor))
	}

}

extension Card.Category {

	var asConsoleText: ConsoleTextFragment {
		switch self {
		case .person(.man):
			return .init(string: description, style: .init(color: .custom(r: 65, g: 105, b: 225)))
		case .person(.woman):
			return .init(string: description, style: .init(color: .custom(r: 218, g: 112, b: 214)))
		case .location(.indoors):
			return .init(string: description, style: .init(color: .custom(r: 128, g: 128, b: 128)))
		case .location(.outdoors):
			return .init(string: description, style: .init(color: .custom(r: 46, g: 139, b: 87)))
		case .weapon(.melee):
			return .init(string: description, style: .init(color: .custom(r: 240, g: 255, b: 240)))
		case .weapon(.ranged):
			return .init(string: description, style: .init(color: .custom(r: 245, g: 222, b: 179)))
		}
	}

}

extension Card.Color {

	var consoleTextColor: ConsoleColor {
		switch self {
		case .blue:
			return .custom(r: 30, g: 144, b: 255)
		case .green:
			return .custom(r: 34, g: 139, b: 34)
		case .purple:
			return .custom(r: 138, g: 43, b: 226)
		case .brown:
			return .custom(r: 139, g: 69, b: 19)
		case .gray:
			return .custom(r: 192, g: 192, b: 192)
		case .orange:
			return .custom(r: 255, g: 140, b: 0)
		case .pink:
			return .custom(r: 240, g: 128, b: 128)
		case .red:
			return .custom(r: 139, g: 0, b: 0)
		case .white:
			return .white
		case .yellow:
			return .custom(r: 255, g: 215, b: 0)
		}
	}

	var asConsoleText: ConsoleTextFragment {
		.init(string: description, style: .init(color: consoleTextColor))
	}
}

extension Card.Filter {

	var asConsoleText: ConsoleTextFragment {
		switch self {
		case .color(let color):
			return color.asConsoleText
		case .category(let category):
			return category.asConsoleText
		}
	}

}
