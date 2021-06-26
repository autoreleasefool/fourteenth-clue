//
//  CardPosition.swift
//  Fourteenth Clue
//
//  Created by Joseph Roque on 2021-06-23.
//

enum CardPosition {
	case leftCard
	case rightCard
	case person
	case location
	case weapon

	var category: Card.Category? {
		switch self {
		case .leftCard, .rightCard:
			return nil
		case .person:
			return .person
		case .location:
			return .location
		case .weapon:
			return .weapon
		}
	}
}
