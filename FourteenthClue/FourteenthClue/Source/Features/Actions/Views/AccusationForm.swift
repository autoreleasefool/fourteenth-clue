//
//  AccusationForm.swift
//  Fourteenth Clue
//
//  Created by Joseph Roque on 2021-07-04.
//

import FourteenthClueKit
import SwiftUI

struct AccusationForm: View {

	@ObservedObject var viewModel: NewActionViewModel
	let onAddAccusation: (Accusation) -> Void

	var body: some View {
		Group {
			Section {
				Picker("Accusing Player", selection: $viewModel.viewState.accusation.accusingPlayer) {
					ForEach(viewModel.state.players) { player in
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
					let accusation = viewModel.viewState.accusation.build(withState: viewModel.state)
					onAddAccusation(accusation)
				}
			}
		}
		.sheet(item: $viewModel.viewState.accusation.pickingCardPosition) { cardPosition in
			CardPicker(categories: cardPosition.categories, fromAvailableCards: viewModel.state.allCards, allowsRemoval: false) {
				guard let card = $0 else { return }
				switch cardPosition {
				case .hiddenLeft, .hiddenRight:
					break
				case .person:
					viewModel.viewState.accusation.person = card
				case .location:
					viewModel.viewState.accusation.location = card
				case .weapon:
					viewModel.viewState.accusation.weapon = card
				}
			}
		}
	}

	private func cardRow(for cardPosition: Card.Position) -> some View {
		Button {
			viewModel.viewState.accusation.pickingCardPosition = cardPosition
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
			return viewModel.viewState.accusation.person
		case .location:
			return viewModel.viewState.accusation.location
		case .weapon:
			return viewModel.viewState.accusation.weapon
		}
	}

}
