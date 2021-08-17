//
//  AccusationForm.swift
//  Fourteenth Clue
//
//  Created by Joseph Roque on 2021-07-04.
//

import FourteenthClueKit
import SwiftUI

struct AccusationForm: View {

	private let state: GameState
	private let onAddClue: (AnyClue) -> Void

	@State private var accusingPlayer: Player
	@State private var person: Card = Card.peopleCards.sorted().first!
	@State private var location: Card = Card.locationsCards.sorted().first!
	@State private var weapon: Card = Card.weaponsCards.sorted().first!
	@State private var pickingCardPosition: Card.Position?

	init(state: GameState, onAddClue: @escaping (AnyClue) -> Void) {
		self.state = state
		self.onAddClue = onAddClue
		self._accusingPlayer = .init(initialValue: state.players.first!)
	}

	var body: some View {
		Group {
			Section {
				Picker("Accusing Player", selection: $accusingPlayer) {
					ForEach(state.players) { player in
						Text(player.name)
							.tag(player)
					}
				}
			}

			Section {
				cardRow(for: .person)
				cardRow(for: .location)
				cardRow(for: .weapon)
			}

			Section {
				Button("Submit") {
					onAddClue(AnyClue(Accusation(
						ordinal: state.actions.count,
						accusingPlayer: accusingPlayer.id,
						accusation: MysteryCardSet(person: person, location: location, weapon: weapon)
					)))
				}
			}
		}
		.sheet(item: $pickingCardPosition) { cardPosition in
			CardPicker(categories: cardPosition.categories, fromAvailableCards: state.allCards, allowsRemoval: false) {
				guard let card = $0 else { return }
				switch cardPosition {
				case .hiddenLeft, .hiddenRight:
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

	private func cardRow(for cardPosition: Card.Position) -> some View {
		Button {
			pickingCardPosition = cardPosition
		} label: {
			if let card = card(for: cardPosition) {
				CardImage(card: card)
					.showingCardName()
					.size(.small)
			}
		}
	}

	private func card(for cardPosition: Card.Position) -> Card? {
		switch cardPosition {
		case .hiddenLeft, .hiddenRight:
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
