//
//  Card.swift
//  Fourteenth Clue
//
//  Created by Joseph Roque on 2021-06-22.
//

import SwiftUI

enum Card: String, CaseIterable, Comparable, Hashable {

	case harbor
	case library
	case market
	case museum
	case park
	case parlor
	case plaza
	case racecourse
	case railcar
	case theater

	case butcher
	case coachman
	case countess
	case dancer
	case duke
	case florist
	case maid
	case nurse
	case officer
	case sailor

	case blowgun
	case bow
	case candlestick
	case crossbow
	case gun
	case hammer
	case knife
	case poison
	case rifle
	case sword

	init?(fromSeed seedName: String) {
		guard let card = Card(rawValue: seedName.lowercased()) else { return nil }
		self = card
	}

	var image: UIImage {
		UIImage(named: "Cards/\(category.basicDescription)/\(rawValue)")!
	}

	var name: String {
		rawValue[rawValue.startIndex].uppercased()
			+ rawValue[rawValue.index(after: rawValue.startIndex)...]
	}

	static func < (lhs: Card, rhs: Card) -> Bool {
		(lhs.color, lhs.category, lhs.rawValue) < (rhs.color, rhs.category, rhs.rawValue)
	}

	static func cardSet(forPlayerCount playerCount: Int) -> Set<Card> {
		var availableCards = Set(Card.allCases)

		switch playerCount {
		case 2:
			availableCards.subtract(Card.orangeCards)
			fallthrough
		case 3:
			availableCards.subtract(Card.whiteCards)
			fallthrough
		case 4:
			availableCards.subtract(Card.brownCards)
			fallthrough
		case 5:
			availableCards.subtract(Card.grayCards)
		default:
			break
		}

		return availableCards
	}

}

// MARK: Category

extension Card {

	enum Category: Hashable, Equatable, CaseIterable, CustomStringConvertible, Identifiable, Comparable {

		case person(Gender)
		case location(Presence)
		case weapon(Class)

		enum Gender: String, Hashable, Equatable, Identifiable {
			case man
			case woman

			var id: String {
				rawValue
			}
		}

		enum Presence: String, Hashable, Equatable, Identifiable {
			case indoors
			case outdoors

			var id: String {
				rawValue
			}
		}

		enum Class: String, Hashable, Equatable, Identifiable {
			case melee
			case ranged

			var id: String {
				rawValue
			}
		}

		fileprivate var basicDescription: String {
			switch self {
			case .person: return "person"
			case .location: return "location"
			case .weapon: return "weapon"
			}
		}

		var description: String {
			switch self {
			case .person(.man):
				return "Male"
			case .person(.woman):
				return "Female"
			case .location(.indoors):
				return "Indoors"
			case .location(.outdoors):
				return "Outdoors"
			case .weapon(.melee):
				return "Melee"
			case .weapon(.ranged):
				return "Ranged"
			}
		}

		var id: String {
			description
		}

		static var allCases: [Category] {
			[.person(.man), .person(.woman), .location(.indoors), .location(.outdoors), .weapon(.melee), .weapon(.ranged)]
		}

		static func < (lhs: Category, rhs: Category) -> Bool {
			switch (lhs, rhs) {
			case (.person, .location), (.person, .weapon):
				return true
			case (.location, .weapon):
				return true
			case (.person, person), (.location, .person), (.location, .location),
				(.weapon, .person), (.weapon, .location), (.weapon, .weapon):
				return false
			}
		}

	}

	var category: Category {
		switch self {
		case .harbor, .market, .park, .plaza, .racecourse:
			return .location(.outdoors)
		case .library, .museum, .parlor, .railcar, .theater:
			return .location(.indoors)

		case .butcher, .coachman, .duke, .officer, .sailor:
			return .person(.man)
		case .countess, .dancer, .florist, .maid, .nurse:
			return .person(.woman)

		case .blowgun, .bow, .crossbow, .gun, .rifle:
			return .weapon(.ranged)
		case .candlestick, .hammer, .knife, .poison, .sword:
			return .weapon(.melee)
		}
	}

	static func allCardsMatching(filter: Inquisition.Filter) -> Set<Card> {
		Set(Card.allCases.filter { card in
			switch filter {
			case .color(let color):
				return color == card.color
			case .category(let category):
				return category == card.category
			}
		})
	}

	static func allCardsMatching(filter: Inquiry.Category) -> Set<Card> {
		Set(Card.allCases.filter { card in
			switch filter {
			case .color(let color):
				return color == card.color
			case .category(let category):
				return category == card.category
			}
		})
	}

	static func allCardsMatching(category: Card.Category) -> Set<Card> {
		Set(Card.allCases.filter { card in
			switch (category, card.category) {
			case (.person, .person), (.location, .location), (.weapon, .weapon):
				return true
			default:
				return false
			}
		})
	}

}

// MARK: Color

extension Card {

	enum Color: Int, CaseIterable, CustomStringConvertible, Identifiable, Comparable {

		case purple
		case pink
		case red
		case green
		case yellow
		case blue
		case orange
		case white
		case brown
		case gray

		var description: String {
			switch self {
			case .purple:
				return "Purple"
			case .pink:
				return "Pink"
			case .red:
				return "Red"
			case .green:
				return "Green"
			case .yellow:
				return "Yellow"
			case .blue:
				return "Blue"
			case .orange:
				return "Orange"
			case .white:
				return "White"
			case .brown:
				return "Brown"
			case .gray:
				return "Gray"
			}
		}

		var id: Int {
			rawValue
		}

		static func < (lhs: Color, rhs: Color) -> Bool {
			lhs.rawValue < rhs.rawValue
		}

	}

	var color: Color {
		switch self {
		case .officer, .parlor, .knife:
			return .purple
		case .duke, .market, .crossbow:
			return .pink
		case .butcher, .library, .poison:
			return .red
		case .countess, .park, .sword:
			return .green
		case .nurse, .museum, .blowgun:
			return .yellow
		case .maid, .harbor, .rifle:
			return .blue
		case .dancer, .theater, .gun:
			return .orange
		case .sailor, .plaza, .candlestick:
			return .white
		case .florist, .railcar, .hammer:
			return .brown
		case .coachman, .racecourse, .bow:
			return .gray
		}
	}

	static let purpleCards: Set<Card> = { Set(Card.allCases.filter { $0.color == .purple }) }()
	static let pinkCards: Set<Card> = { Set(Card.allCases.filter { $0.color == .pink }) }()
	static let redCards: Set<Card> = { Set(Card.allCases.filter { $0.color == .red }) }()
	static let greenCards: Set<Card> = { Set(Card.allCases.filter { $0.color == .green }) }()
	static let yellowCards: Set<Card> = { Set(Card.allCases.filter { $0.color == .yellow }) }()
	static let blueCards: Set<Card> = { Set(Card.allCases.filter { $0.color == .blue }) }()
	static let orangeCards: Set<Card> = { Set(Card.allCases.filter { $0.color == .orange }) }()
	static let whiteCards: Set<Card> = { Set(Card.allCases.filter { $0.color == .white }) }()
	static let brownCards: Set<Card> = { Set(Card.allCases.filter { $0.color == .brown }) }()
	static let grayCards: Set<Card> = { Set(Card.allCases.filter { $0.color == .gray }) }()

}

// MARK: People

extension Card {

	static let menCards: Set<Card> = { Set(Card.allCases.filter { $0.category == .person(.man) }) }()
	static let womenCards: Set<Card> = { Set(Card.allCases.filter { $0.category == .person(.woman) }) }()
	static let peopleCards: Set<Card> = { menCards.union(womenCards) }()

}

// MARK: Weapons

extension Card {

	static let rangedCards: Set<Card> = { Set(Card.allCases.filter { $0.category == .weapon(.ranged) }) }()
	static let meleeCards: Set<Card> = { Set(Card.allCases.filter { $0.category == .weapon(.melee) }) }()
	static let weaponsCards: Set<Card> = { rangedCards.union(meleeCards) }()

}

// MARK: Locations

extension Card {

	static let outdoorsCards: Set<Card> = { Set(Card.allCases.filter { $0.category == .location(.outdoors) }) }()
	static let indoorsCards: Set<Card> = { Set(Card.allCases.filter { $0.category == .location(.indoors) }) }()
	static let locationsCards: Set<Card> = { outdoorsCards.union(indoorsCards) }()

}

// MARK: Clues

extension Set where Element == Card {

	var people: Set<Card> {
		self.intersection(Card.peopleCards)
	}

	var locations: Set<Card> {
		self.intersection(Card.locationsCards)
	}

	var weapons: Set<Card> {
		self.intersection(Card.weaponsCards)
	}

	func matching(filter: Inquisition.Filter) -> Set<Card> {
		self.intersection(Card.allCardsMatching(filter: filter))
	}

}
