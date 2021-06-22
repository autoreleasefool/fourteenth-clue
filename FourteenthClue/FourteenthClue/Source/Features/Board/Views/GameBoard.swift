//
//  GameBoard.swift
//  Fourteenth Clue
//
//  Created by Joseph Roque on 2021-06-22.
//

import SwiftUI

struct GameBoard: View {

	@StateObject private var viewModel: GameBoardViewModel

	init(playerCount: Int) {
		self._viewModel = .init(wrappedValue: GameBoardViewModel(playerCount: playerCount))
	}

	var body: some View {
		ScrollView {
			VStack {
				EmptyView()
			}
		}
		.navigationTitle("13 Clues")
		.navigationBarBackButtonHidden(true)
		.onAppear {
			viewModel.onAppear()
		}
	}

}
