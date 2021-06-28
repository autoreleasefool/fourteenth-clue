//
//  CardPicker.swift
//  Fourteenth Clue
//
//  Created by Joseph Roque on 2021-06-23.
//

import SwiftUI

struct CardPicker: View {

	let pickableCards: [Card]
	let onCardPicked: (Card?) -> Void

	init(cards: [Card], onCardPicked: @escaping (Card?) -> Void) {
		self.onCardPicked = onCardPicked
		self.pickableCards = cards
	}

	init(categories: Set<Card.Category> = [], onCardPicked: @escaping (Card?) -> Void) {
		let cards = Card.allCases
			.filter { categories.isEmpty || categories.contains($0.category) }
			.sorted()

		self.init(cards: cards, onCardPicked: onCardPicked)
	}

	var body: some View {
		List {
			Section("Select a card") {
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

}
