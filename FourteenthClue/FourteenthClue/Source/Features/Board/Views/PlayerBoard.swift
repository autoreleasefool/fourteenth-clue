//
//  PlayerBoard.swift
//  Fourteenth Clue
//
//  Created by Joseph Roque on 2021-06-23.
//

import FourteenthClueKit
import SwiftUI

struct PlayerBoard: View {

	@ObservedObject var viewModel: GameBoardViewModel
	let player: Player

	@State var pickingCardPosition: Card.Position?

	var body: some View {
		VStack(alignment: .leading) {
			Text(player.name)
				.font(.headline)
				.padding(.vertical, 8)
				.padding(.leading, 16)

			if viewModel.state.isTrackingMagnifyingGlasses {
				Text("Magnifying glasses: \(player.magnifyingGlasses)")
					.font(.caption)
					.padding(.bottom, 8)
					.padding(.leading, 16)
			}

			HStack {
				Spacer()

				CardImage(card: player.mystery.person)
					.size(.medium)
					.onTapGesture {
						pickingCardPosition = .person
					}

				Spacer()

				CardImage(card: player.mystery.location)
					.size(.medium)
					.onTapGesture {
						pickingCardPosition = .location
					}

				Spacer()

				CardImage(card: player.mystery.weapon)
					.size(.medium)
					.onTapGesture {
						pickingCardPosition = .weapon
					}

				Spacer()
			}

			HStack {
				Spacer()

				CardImage(card: player.hidden.left)
					.size(.small)
					.onTapGesture {
						pickingCardPosition = .hiddenLeft
					}

				Spacer()

				CardImage(card: player.hidden.right)
					.size(.small)
					.onTapGesture {
						pickingCardPosition = .hiddenRight
					}

				Spacer()
			}
		}
		.padding()
		.sheet(item: $pickingCardPosition) { cardPosition in
			CardPicker(categories: cardPosition.categories, fromAvailableCards: viewModel.state.unallocatedCards) {
				pickingCardPosition = nil
				viewModel.setCard($0, forPlayer: player, atPosition: cardPosition)
			}
		}
	}

}
