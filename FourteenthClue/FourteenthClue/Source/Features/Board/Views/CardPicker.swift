//
//  CardPicker.swift
//  Fourteenth Clue
//
//  Created by Joseph Roque on 2021-06-23.
//

import SwiftUI

struct CardPicker: View {
	@Environment(\.dismiss) private var dismiss

	let pickableCards: [Card]
	let allowsRemoval: Bool
	let onCardPicked: (Card?) -> Void

	init(cards: [Card], allowsRemoval: Bool = true, onCardPicked: @escaping (Card?) -> Void) {
		self.onCardPicked = onCardPicked
		self.allowsRemoval = allowsRemoval
		self.pickableCards = cards
	}

	init(
		categories: Set<Card.Category> = [],
		fromAvailableCards availableCards: Set<Card> = Set(Card.allCases),
		allowsRemoval: Bool = true,
		onCardPicked: @escaping (Card?) -> Void
	) {
		let cards = availableCards
			.filter { categories.isEmpty || categories.contains($0.category) }
			.sorted()

		self.init(cards: cards, allowsRemoval: allowsRemoval, onCardPicked: onCardPicked)
	}

	var body: some View {
		List {
			Section("Select a card") {
				if allowsRemoval {
					cardRow(for: nil)
				}
				ForEach(pickableCards, id: \.rawValue) { card in
					cardRow(for: card)
				}
			}
		}
	}

	private func cardRow(for card: Card?) -> some View {
		Button {
			onCardPicked(card)
			dismiss()
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
