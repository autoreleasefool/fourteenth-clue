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

extension Card {
	var image: UIImage {
		UIImage(named: "Cards/\(category.broadDescription)/\(rawValue)")!
	}
}
