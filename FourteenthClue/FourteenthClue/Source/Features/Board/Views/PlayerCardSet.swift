//
//  PlayerCardSet.swift
//  Fourteenth Clue
//
//  Created by Joseph Roque on 2021-06-23.
//

import BottomSheet
import SwiftUI

struct PlayerCardSet: View {

	let player: GameState.Player
	let onSetCard: (Card?, CardPosition) -> Void

	@State var pickingCardPosition: CardPosition?

	var body: some View {
		GeometryReader { fullView in
			VStack {
				Text("Player")
				HStack {
					Rectangle()
						.fill(Color.red)
						.frame(width: fullView.size.width / 3, height: 150)
						.onTapGesture {
							pickingCardPosition = .leftCard
						}
					Rectangle()
						.fill(Color.blue)
						.frame(width: fullView.size.width / 3, height: 150)
						.onTapGesture {
							pickingCardPosition = .rightCard
						}
				}
			}
		}
		.bottomSheet(item: $pickingCardPosition) {
			CardPicker(category: pickingCardPosition?.category) {
				guard let cardPosition = pickingCardPosition else { return }
				pickingCardPosition = nil
				onSetCard($0, cardPosition)
			}
		}
	}

}
