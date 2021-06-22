//
//  Card.swift
//  Fourteenth Clue
//
//  Created by Joseph Roque on 2021-06-22.
//

import SwiftUI

enum Card: CaseIterable {

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

}

// MARK: Category

extension Card {

	enum Category {

		case person
		case location
		case weapon

	}

	var category: Category {
		switch self {
		case .harbor, .library, .market, .museum, .park, .parlor, .plaza, .raceCourse, .railCar, .theater:
			return .location

		case .butcher, .coachman, .countess, .dancer, .duke, .florist, .maid, .nurse, .officer, .sailor:
			return .person

		case .blowgun, .bow, .candlestick, .crossbow, .gun, .hammer, .knife, .poison, .rifle, .sword:
			return .weapon
		}
	}

}

// MARK: Color

extension Card {

	enum Color {

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
	}

	var color: Color {
		switch self {
		case .officer, .parlor, .knife: return .purple
		case .duke, .market, .crossbow: return .pink
		case .butcher, .library, .poison: return .red
		case .countess, .park, .sword: return .green
		case .nurse, .museum, .blowgun: return .yellow
		case .maid, .harbor, .rifle: return .blue
		case .dancer, .theater, .gun: return .orange
		case .sailor, .plaza, .candlestick: return .white
		case .florist, .railCar, .hammer: return .brown
		case .coachman, .raceCourse, .bow: return .gray
		}
	}

}

// MARK: People

extension Card {

	static let people: Set<Card> = { Set(Card.allCases.filter { $0.category == .person }) }()
	static let men: Set<Card> = [.butcher, .coachman, .duke, .officer, .sailor]
	static let women: Set<Card> = [.countess, .dancer, .florist, .maid, .nurse]

}

// MARK: Weapons

extension Card {

	static let weapons: Set<Card> = { Set(Card.allCases.filter { $0.category == .weapon }) }()
	static let ranged: Set<Card> = [.blowgun, .bow, .crossbow, .gun, .rifle]
	static let melee: Set<Card> = [.candlestick, .hammer, .knife, .poison, .sword]

}

// MARK: Locations

extension Card {

	static let locations: Set<Card> = { Set(Card.allCases.filter { $0.category == .location }) }()
	static let outdoors: Set<Card> = [.harbor, .market, .park, .plaza, .raceCourse]
	static let indoors: Set<Card> = [.library, .museum, .parlor, .railCar, .theater]

}
