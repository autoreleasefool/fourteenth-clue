//
//  Card+Position.swift
//  FourteenthClue
//
//  Created by Joseph Roque on 2021-08-18.
//

import FourteenthClueKit

extension Card {

	enum Position: String, Identifiable, CaseIterable {
		case person
		case location
		case weapon
		case hiddenLeft
		case hiddenRight

		var id: String {
			rawValue
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



