//
//  Solution.swift
//  Fourteenth Clue
//
//  Created by Joseph Roque on 2021-06-28.
//

import Foundation

struct Solution: Equatable, Comparable, Identifiable {

	let person: Card
	let location: Card
	let weapon: Card

	let probability: Double

	var id: String {
		"\(person)/\(location)/\(weapon)"
	}

	static func < (lhs: Solution, rhs: Solution) -> Bool {
		lhs.probability < rhs.probability
	}

}
