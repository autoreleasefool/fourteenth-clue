//
//  CardPicker.swift
//  Fourteenth Clue
//
//  Created by Joseph Roque on 2021-06-23.
//

import SwiftUI

struct CardPicker: View {

	let category: Card.Category?
	let pickableCards: [Card]
	let onCardPicked: (Card?) -> Void

	init(category: Card.Category? = nil, onCardPicked: @escaping (Card?) -> Void) {
		self.category = category
		self.onCardPicked = onCardPicked
		self.pickableCards = Card.allCases
			.filter { category == nil || $0.category == category }
			.sorted {
				if $0.color.rawValue == $1.color.rawValue {
					return $0.rawValue < $1.rawValue
				} else {
					return $0.color.rawValue < $1.color.rawValue
				}
			}
	}

	var body: some View {
		List {
			Section(title) {
				cardRow(for: nil)
				ForEach(pickableCards, id: \.rawValue) { card in
					cardRow(for: card)
				}
			}
		}
	}

	private func cardRow(for card: Card?) -> some View {
		Button {
			onCardPicked(card)
		} label: {
			HStack {
				Image(uiImage: card?.image ?? Assets.Images.Cards.back)
					.resizable()
					.clipShape(RoundedRectangle(cornerRadius: 8))
					.frame(width: 60, height: 100)

				Text(card?.name ?? "Remove card")
					.foregroundColor(card == nil ? .red : .black)

				Spacer()
			}
		}
	}

	// MARK: Strings

	private var title: String {
		if let category = category {
			return "Select a \(category.rawValue)"
		} else {
			return "Select a card"
		}
	}

}
