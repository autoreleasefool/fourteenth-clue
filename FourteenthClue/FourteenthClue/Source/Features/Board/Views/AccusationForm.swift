//
//  AccusationForm.swift
//  Fourteenth Clue
//
//  Created by Joseph Roque on 2021-07-04.
//

import SwiftUI

struct AccusationForm: View {

	private let state: GameState
	private let onAddClue: (AnyClue) -> Void

	@State private var selectedPlayer: Player
	@State private var person: Card = Card.peopleCards.first!
	@State private var location: Card = Card.locationsCards.first!
	@State private var weapon: Card = Card.weaponsCards.first!
	@State private var pickingCardPosition: CardPosition?

	init(state: GameState, onAddClue: @escaping (AnyClue) -> Void) {
		self.state = state
		self.onAddClue = onAddClue
		self._selectedPlayer = .init(initialValue: state.players.first!)
	}

	var body: some View {
		Group {
			Section {
				cardRow(for: .person)
				cardRow(for: .location)
				cardRow(for: .weapon)
			}

			Section {
				Button("Submit") {
					onAddClue(AnyClue(Accusation(
						player: selectedPlayer.id,
						accusation: MysteryCardSet(person: person, location: location, weapon: weapon)
					)))
				}
			}
		}
		.sheet(item: $pickingCardPosition) { cardPosition in
			CardPicker(categories: cardPosition.categories, fromAvailableCards: state.allCards, allowsRemoval: false) {
				guard let card = $0 else { return }
				switch cardPosition {
				case .rightCard, .leftCard:
					break
				case .person:
					person = card
				case .location:
					location = card
				case .weapon:
					weapon = card
				}
			}
		}
	}

	private func cardRow(for cardPosition: CardPosition) -> some View {
		Button {
			pickingCardPosition = cardPosition
		} label: {
			HStack {
				if let card = card(for: cardPosition) {
					Image(uiImage: card.image)
						.resizable()
						.clipShape(RoundedRectangle(cornerRadius: 8))
						.frame(width: 60, height: 100)

					Text(card.name)
				}

				Spacer()
			}
		}
	}

	private func card(for cardPosition: CardPosition) -> Card? {
		switch cardPosition {
		case .leftCard, .rightCard:
			return nil
		case .person:
			return person
		case .location:
			return location
		case .weapon:
			return weapon
		}
	}

}
