//
//  Card+Position.swift
//  Card+Position
//
//  Created by Joseph Roque on 2021-08-17.
//

import FourteenthClueKit

extension Card {

	enum Position: String, Identifiable {
		case person
		case location
		case weapon
		case hiddenLeft
		case hiddenRight

		var id: String {
			rawValue
		}

		var name: String {
			rawValue.capitalized
		}

		var categories: Set<Card.Category> {
				switch self {
				case .hiddenLeft, .hiddenRight:
					return []
				case .person:
					return [.person(.man), .person(.woman)]
				case .location:
					return [.location(.indoors), .location(.outdoors)]
				case .weapon:
					return [.weapon(.melee), .weapon(.ranged)]
				}
			}
	}

}
