//
//  GameBoard.swift
//  Fourteenth Clue
//
//  Created by Joseph Roque on 2021-06-22.
//

import SwiftUI

struct GameBoard: View {

	@StateObject var viewModel: GameBoardViewModel

	init(state: GameState) {
		self._viewModel = .init(wrappedValue: GameBoardViewModel(state: state))
	}

	var body: some View {
		TabView {
			ForEach(0..<viewModel.state.players.count) { player in
				ScrollView {
					PlayerCardSet(player: viewModel.state.players[player]) { card, position in
						viewModel.setCard(card, forPlayer: player, atPosition: position)
					}
				}
			}
		}
		.tabViewStyle(.page)
		.navigationTitle("13 Clues")
		.navigationBarBackButtonHidden(true)
		.onAppear {
			viewModel.onAppear()
		}
	}

}
