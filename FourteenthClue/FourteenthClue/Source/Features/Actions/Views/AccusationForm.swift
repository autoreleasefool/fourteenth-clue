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
				CirclePicker(
					pickableItems: viewModel.state.players,
					selectedItem: $viewModel.viewState.accusation.accusingPlayer
				) { player in
					Text(player.name.prefix(2).capitalized)
				}
				.titled("Accusing Player")
				.padding(.vertical)
			}

			Section {
				CirclePicker(
					pickableItems: viewModel.state.peopleCards.sorted(),
					selectedItem: $viewModel.viewState.accusation.person
				) { card in
					Image(uiImage: card.image)
						.resizable()
				}
				.titled("Person")
				.padding(.vertical)

				CirclePicker(
					pickableItems: viewModel.state.locationsCards.sorted(),
					selectedItem: $viewModel.viewState.accusation.location
				) { card in
					Image(uiImage: card.image)
						.resizable()
				}
				.titled("Location")
				.padding(.vertical)

				CirclePicker(
					pickableItems: viewModel.state.weaponsCards.sorted(),
					selectedItem: $viewModel.viewState.accusation.weapon
				) { card in
					Image(uiImage: card.image)
						.resizable()
				}
				.titled("Weapon")
				.padding(.vertical)
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

#if DEBUG
struct AccusationnFormPreview: PreviewProvider {
	static let gameState = GameState(playerCount: 4)

	static var previews: some View {
		Form {
			AccusationForm(
				viewModel: .init(
					state: gameState,
					initialViewState: .init(state: gameState)
				)
			) { _ in }
		}
	}
}
#endif
