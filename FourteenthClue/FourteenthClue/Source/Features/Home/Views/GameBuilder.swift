//
//  GameBuilder.swift
//  Fourteenth Clue
//
//  Created by Joseph Roque on 2021-06-23.
//

import FourteenthClueKit
import SwiftUI

struct GameBuilder: View {

	@StateObject private var viewModel: GameBuilderViewModel

	init(playerCount: Int) {
		self._viewModel = .init(wrappedValue: GameBuilderViewModel(playerCount: playerCount))
	}

	var body: some View {
		Form {
			ForEach(0..<viewModel.playerCount) { index in
				Section(header: Text(viewModel.getTitle(forPlayer: index))) {
					TextField(viewModel.getTitle(forPlayer: index), text: $viewModel.playerNames[index])

					if let intermediateState = viewModel.intermediateState {
						intermediateCards(forPlayer: index, in: intermediateState)
					}
				}
			}

			Section(header: Text("Initial state")) {
				TextEditor(text: $viewModel.initialJSONState)
					.font(.caption)
					.onChange(of:  viewModel.initialJSONState) { _ in
						viewModel.formatJSON()
					}
			}
		}
		.navigationTitle("Create new game")
		.navigationBarItems(trailing: startButton)
		.navigate(using: $viewModel.gameState) { gameState in
			GameBoard(state: gameState)
		}
	}

	private func intermediateCards(forPlayer index: Int, in state: GameState) -> some View {
		HStack {
			if index == 0 {
				CardImage(card: state.players[index].hidden.left)
					.size(.small)
				CardImage(card: state.players[index].hidden.right)
					.size(.small)
			} else {
				CardImage(card: state.players[index].mystery.person)
					.size(.small)
				CardImage(card: state.players[index].mystery.location)
					.size(.small)
				CardImage(card: state.players[index].mystery.weapon)
					.size(.small)
			}
		}
	}

	private var startButton: some View {
		Button("Start") {
			viewModel.startGame()
		}
	}

}
