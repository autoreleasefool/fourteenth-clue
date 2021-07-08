//
//  PlayerCardSet.swift
//  Fourteenth Clue
//
//  Created by Joseph Roque on 2021-06-23.
//

import SwiftUI

struct PlayerCardSet: View {

	@ObservedObject var viewModel: GameBoardViewModel
	let player: Player
//	let onSetCard: (Card?, GameState.CardPosition) -> Void

	@State var pickingCardPosition: CardPosition?

	var body: some View {
		GeometryReader { fullView in
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

					CardImage(card: player.privateCards.leftCard)
						.size(.medium)
						.onTapGesture {
							pickingCardPosition = .leftCard
						}

					Spacer()

					CardImage(card: player.privateCards.rightCard)
						.size(.medium)
						.onTapGesture {
							pickingCardPosition = .rightCard
						}

					Spacer()
				}
			}
			.padding()
		}
		.sheet(item: $pickingCardPosition) { cardPosition in
			CardPicker(categories: cardPosition.categories, fromAvailableCards: viewModel.unallocatedCards) {
				pickingCardPosition = nil
				viewModel.setCard($0, forPlayer: player, atPosition: cardPosition)
//				onSetCard($0, cardPosition)
			}
		}
	}

}
