//
//  CirclePicker.swift
//  Fourteenth Clue
//
//  Created by Joseph Roque on 2021-10-30.
//

import FourteenthClueKit
import SwiftUI

struct CirclePicker<Pickable: Identifiable, Content: View>: View {

	let pickableItems: [Pickable]

	@Binding
	var selectedItem: Pickable

	var subtitle: ((Pickable) -> String)?

	@ViewBuilder
	var pickableView: (Pickable) -> Content

	init(
		pickableItems: [Pickable],
		selectedItem: Binding<Pickable>,
		subtitle: ((Pickable) -> String)? = nil,
		@ViewBuilder pickableView: @escaping (Pickable) -> Content
	) {
		self.pickableItems = pickableItems
		self._selectedItem = selectedItem
		self.subtitle = subtitle
		self.pickableView = pickableView
	}

	var body: some View {
		LazyVGrid(columns: [GridItem(.adaptive(minimum: 44, maximum: 120))], spacing: 16) {
			ForEach(pickableItems) { item in
				VStack(spacing: 4) {
					CirclePickerCircle(isSelected: item.id == selectedItem.id) {
						pickableView(item)
					}

					if let subtitle = subtitle {
						Text(subtitle(item))
							.font(.footnote)
							.truncationMode(.tail)
							.lineLimit(1)
					}
				}
				.onTapGesture {
					selectedItem = item
				}
			}
		}
	}

}

extension CirclePicker {

	func titled(_ title: String) -> some View {
		VStack(alignment: .leading) {
			Text(title)
			self
		}
	}

}

#if DEBUG
struct CirclePickerPreview: PreviewProvider {
	static let gameState = GameState(playerCount: 4)
	static let viewModel = NewActionViewModel(state: gameState, initialViewState: .init(state: gameState))

	static var previews: some View {
		Form {
			CirclePicker(
				pickableItems: viewModel.state.players,
				selectedItem: .constant(viewModel.viewState.inquisition.askingPlayer),
				subtitle: { $0.name },
				pickableView: { player in
					Text(String(player.name.first!) + String(player.name.dropFirst().first!))
						.padding()
				}
			)
		}
	}

}
#endif
