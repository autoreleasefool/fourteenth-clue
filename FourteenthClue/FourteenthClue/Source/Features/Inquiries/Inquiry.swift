//
//  Inquiry.swift
//  Inquiry
//
//  Created by Joseph Roque on 2021-08-15.
//

struct Inquiry {
	let player: String
	let category: Category
}

extension Inquiry {

	enum Category {
		case category(Card.Category)
		case color(Card.Color)

		var cards: Set<Card> {
			Card.allCardsMatching(filter: self)
		}
	}

}
