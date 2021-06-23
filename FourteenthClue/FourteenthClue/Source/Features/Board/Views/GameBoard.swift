//
//  GameBoard.swift
//  Fourteenth Clue
//
//  Created by Joseph Roque on 2021-06-22.
//

import SwiftUI

struct GameBoard: View {

	@StateObject private var viewModel: GameBoardViewModel

	init(state: GameState) {
		self._viewModel = .init(wrappedValue: GameBoardViewModel(state: state))
	}

	var body: some View {
		ScrollView {
			ScrollView(.horizontal) {
				ForEach(0..<viewModel.state.players.count) { player in
					PlayerCardSet(player: viewModel.state.players[player])
				}
			}
		}
		.navigationTitle("13 Clues")
		.navigationBarBackButtonHidden(true)
		.onAppear {
			viewModel.onAppear()
		}
	}

}
