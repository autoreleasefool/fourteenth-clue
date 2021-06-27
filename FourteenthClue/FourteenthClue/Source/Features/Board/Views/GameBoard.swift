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
		var state = state
		for i in state.players.startIndex..<state.players.endIndex {
			if state.players[i].name.isEmpty {
				state = state.withPlayer(
					state.players[i].withName("Player \(i + 1)"),
					at: i
				)
			}
		}
		self._viewModel = .init(wrappedValue: GameBoardViewModel(state: state))
	}

	var body: some View {
		VStack(spacing: 0) {
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
			.background(Color.gray)
			List {
				Section("Clues") {
					Button("Add new") {

					}
					ForEach(viewModel.state.clues) { clue in
						Text(clue.description(withPlayer: viewModel.state.players[clue.player]))
					}
				}
			}
		}
		.navigationTitle("13 Clues")
		.navigationBarBackButtonHidden(true)
		.onAppear {
			viewModel.onAppear()
		}
	}

	// MARK: Strings

	private func label(for clue: Clue) -> String {
		"\(viewModel.state.players[clue.player].name) sees "
	}
}
