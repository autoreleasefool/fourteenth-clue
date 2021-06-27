//
//  PlayerCardSet.swift
//  Fourteenth Clue
//
//  Created by Joseph Roque on 2021-06-23.
//

import SwiftUI

struct PlayerCardSet: View {

	let player: GameState.Player
	let onSetCard: (Card?, GameState.CardPosition) -> Void

	@State var pickingCardPosition: GameState.CardPosition?

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

					Image(uiImage: player.mystery.person?.image ?? Assets.Images.Cards.back)
						.resizable()
						.frame(width: 80, height: 132)
						.onTapGesture {
							pickingCardPosition = .person
						}

					Spacer()

					Image(uiImage: player.mystery.location?.image ?? Assets.Images.Cards.back)
						.resizable()
						.frame(width: 80, height: 132)
						.onTapGesture {
							pickingCardPosition = .location
						}

					Spacer()

					Image(uiImage: player.mystery.weapon?.image ?? Assets.Images.Cards.back)
						.resizable()
						.frame(width: 80, height: 132)
						.onTapGesture {
							pickingCardPosition = .weapon
						}

					Spacer()
				}

				HStack {
					Spacer()

					Image(uiImage: player.privateCards.leftCard?.image ?? Assets.Images.Cards.back)
						.resizable()
						.frame(width: 60, height: 100)
						.onTapGesture {
							pickingCardPosition = .leftCard
						}

					Spacer()

					Image(uiImage: player.privateCards.rightCard?.image ?? Assets.Images.Cards.back)
						.resizable()
						.frame(width: 60, height: 100)
						.onTapGesture {
							pickingCardPosition = .rightCard
						}

					Spacer()
				}
			}
			.padding()
		}
		.sheet(item: $pickingCardPosition) { cardPosition in
			CardPicker(categories: cardPosition.categories) {
				pickingCardPosition = nil
				onSetCard($0, cardPosition)
			}
		}
	}

}
