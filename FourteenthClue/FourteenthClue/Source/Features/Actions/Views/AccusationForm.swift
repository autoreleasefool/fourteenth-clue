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
				cardPicker(for: .person)
				cardPicker(for: .location)
				cardPicker(for: .weapon)
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

	private func cardPicker(for cardPosition: Card.Position) -> some View {
		return CirclePicker(
			pickableItems: cards(for: cardPosition),
			selectedItem: cardBinding(for: cardPosition),
			subtitle: { $0.name },
			pickableView: { card in
				Image(uiImage: card.image)
					.resizable()
			}
		)
		.titled(cardPosition.name)
		.padding(.vertical)
	}

	private func cards(for cardPosition: Card.Position) -> [Card] {
		switch cardPosition {
		case .hiddenLeft, .hiddenRight:
			return []
		case .person:
			return viewModel.state.peopleCards.sorted()
		case .location:
			return viewModel.state.locationsCards.sorted()
		case .weapon:
			return viewModel.state.weaponsCards.sorted()
		}
	}

	private func cardBinding(for cardPosition: Card.Position) -> Binding<Card> {
		switch cardPosition {
		case .hiddenLeft, .hiddenRight:
			fatalError("Unable to provide binding for \(cardPosition)")
		case .person:
			return $viewModel.viewState.accusation.person
		case .location:
			return $viewModel.viewState.accusation.location
		case .weapon:
			return $viewModel.viewState.accusation.weapon
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
