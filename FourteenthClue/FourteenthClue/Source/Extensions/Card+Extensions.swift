//
//  Card+Extensions.swift
//  Card+Extensions
//
//  Created by Joseph Roque on 2021-08-17.
//

import FourteenthClueKit
import SwiftUI

extension Card.Category {
	var broadDescription: String {
		switch self {
		case .person: return "person"
		case .location: return "location"
		case .weapon: return "weapon"
		}
	}
}

extension Card.Color {
	var fillColor: SwiftUI.Color {
			switch self {
			case .blue:
				return Color(r: 30, g: 144, b: 255)
			case .green:
				return Color(r: 34, g: 139, b: 34)
			case .purple:
				return Color(r: 138, g: 43, b: 226)
			case .brown:
				return Color(r: 139, g: 69, b: 19)
			case .gray:
				return Color(r: 192, g: 192, b: 192)
			case .orange:
				return Color(r: 255, g: 140, b: 0)
			case .pink:
				return Color(r: 240, g: 128, b: 128)
			case .red:
				return Color(r: 139, g: 0, b: 0)
			case .yellow:
				return Color(r: 255, g: 215, b: 0)
			case .white:
				return .white
			}
		}
}

extension Card {
	var image: UIImage {
		UIImage(named: "Cards/\(category.broadDescription)/\(rawValue)")!
	}
}

extension Card.Category {
	var icon: UIImage {
		UIImage(named: "Categories/\(self.description)")!
	}
}
