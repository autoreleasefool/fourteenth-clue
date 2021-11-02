//
//  InquisitionForm.swift
//  Fourteenth Clue
//
//  Created by Joseph Roque on 2021-07-04.
//

import FourteenthClueKit
import SwiftUI

struct InquisitionForm: View {

	@ObservedObject var viewModel: NewActionViewModel
	let onAddInquisition: (Inquisition) -> Void

	let countFormatter: NumberFormatter = {
		let formatter = NumberFormatter()
		formatter.numberStyle = .decimal
		formatter.allowsFloats = false
		return formatter
	}()

	var body: some View {
		Group {
			Section {
				CirclePicker(
					pickableItems: viewModel.state.players,
					selectedItem: $viewModel.viewState.inquisition.askingPlayer
				) { player in
					Text(player.name.prefix(2).capitalized)
				}
				.titled("Asking Player")
				.padding(.vertical)

				CirclePicker(
					pickableItems: viewModel.state.players,
					selectedItem: $viewModel.viewState.inquisition.answeringPlayer
				) { player in
					Text(player.name.prefix(2).capitalized)
				}
				.titled("Answering Player")
				.padding(.vertical)
			}

			Section {
				CirclePicker(
					pickableItems: Card.Property.allCases,
					selectedItem: $viewModel.viewState.inquisition.property
				) { property in
					switch property {
					case .color(let color):
						Circle()
							.fill(color.fillColor)
					case .category(let category):
						Image(uiImage: category.icon)
							.resizable()
					}
				}
				.titled("Category")
				.padding(.vertical)
			}

			if viewModel.state.numberOfPlayers == 4 {
				Section {
					CirclePicker(
						pickableItems: Card.HiddenCardPosition.allCases,
						selectedItem: $viewModel.viewState.inquisition.includingCardOnSide
					) { position in
						Text(position.description.prefix(1).capitalized)
					}
					.titled("Including which hidden card?")
				}
			}

			Section {
				TextField("Count", value: $viewModel.viewState.inquisition.count, formatter: countFormatter)
					.keyboardType(.numberPad)
			}

			Section {
				Button("Submit") {
					guard let inquisition = viewModel.viewState.inquisition.build(withState: viewModel.state) else { return }
					onAddInquisition(inquisition)
				}
			}
		}
	}
}

#if DEBUG
struct InquisitionFormPreview: PreviewProvider {
	static let gameState = GameState(playerCount: 4)

	static var previews: some View {
		Form {
			InquisitionForm(
				viewModel: .init(
					state: gameState,
					initialViewState: .init(state: gameState)
				)
			) { _ in }
		}
	}
}
#endif
