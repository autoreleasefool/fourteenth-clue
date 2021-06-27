//
//  Card.swift
//  Fourteenth Clue
//
//  Created by Joseph Roque on 2021-06-22.
//

import SwiftUI

enum Card: String, CaseIterable {

	case harbor
	case library
	case market
	case museum
	case park
	case parlor
	case plaza
	case raceCourse
	case railCar
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

	var image: UIImage {
		UIImage(named: "Cards/\(category.basicDescription)/\(rawValue)")!
	}

	var name: String {
		rawValue[rawValue.startIndex].uppercased()
			+ rawValue[rawValue.index(after: rawValue.startIndex)...]
	}

}

// MARK: Category

extension Card {

	enum Category: Hashable, Equatable {

		case person(Gender)
		case location(Presence)
		case weapon(Class)

		enum Gender: Hashable, Equatable {
			case man
			case woman
		}

		enum Presence: Hashable, Equatable {
			case indoors
			case outdoors
		}

		enum Class: Hashable, Equatable {
			case melee
			case ranged
		}

		fileprivate var basicDescription: String {
			switch self {
			case .person: return "person"
			case .location: return "location"
			case .weapon: return "weapon"
			}
		}

	}

	var category: Category {
		switch self {
		case .harbor, .market, .park, .plaza, .raceCourse:
			return .location(.outdoors)
		case .library, .museum, .parlor, .railCar, .theater:
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

}

// MARK: Color

extension Card {

	enum Color: Int, CustomStringConvertible {

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
		case .florist, .railCar, .hammer:
			return .brown
		case .coachman, .raceCourse, .bow:
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
