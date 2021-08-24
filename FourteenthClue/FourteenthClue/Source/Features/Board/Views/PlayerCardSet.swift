//
//  PlayerCardSet.swift
//  Fourteenth Clue
//
//  Created by Joseph Roque on 2021-06-23.
//

import FourteenthClueKit
import SwiftUI

struct PlayerCardSet: View {

	@ObservedObject var viewModel: GameBoardViewModel
	let player: Player

	@State var pickingCardPosition: Card.Position?

	var body: some View {
		GeometryReader { _ in
			VStack {
				HStack {
					Text(player.name)
						.font(.headline)
						.padding(.vertical, 8)
						.padding(.leading, 16)
					Spacer()
				}

				HStack {
					Spacer()

					CardImage(card: player.mystery.person)
						.size(.large)
						.onTapGesture {
							pickingCardPosition = .person
						}

					Spacer()

					CardImage(card: player.mystery.location)
						.size(.large)
						.onTapGesture {
							pickingCardPosition = .location
						}

					Spacer()

					CardImage(card: player.mystery.weapon)
						.size(.large)
						.onTapGesture {
							pickingCardPosition = .weapon
						}

					Spacer()
				}

				HStack {
					Spacer()

					CardImage(card: player.hidden.left)
						.size(.medium)
						.onTapGesture {
							pickingCardPosition = .hiddenLeft
						}

					Spacer()

					CardImage(card: player.hidden.right)
						.size(.medium)
						.onTapGesture {
							pickingCardPosition = .hiddenRight
						}

					Spacer()
				}
			}
			.padding()
		}
		.sheet(item: $pickingCardPosition) { cardPosition in
			CardPicker(categories: cardPosition.categories, fromAvailableCards: viewModel.state.unallocatedCards) {
				pickingCardPosition = nil
				viewModel.setCard($0, forPlayer: player, atPosition: cardPosition)
			}
		}
	}

}
