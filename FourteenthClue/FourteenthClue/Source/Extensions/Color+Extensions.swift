//
//  Color+Extensions.swift
//  Fourteenth Clue
//
//  Created by Joseph Roque on 2021-11-01.
//

import SwiftUI

extension Color {
	// swiftlint:disable identifier_name
	init(r: Int, g: Int, b: Int) {
		self.init(red: Double(r) / 255.0, green: Double(g) / 255.0, blue: Double(b) / 255.0)
	}
	// swiftlint:enable identifier_name
}
