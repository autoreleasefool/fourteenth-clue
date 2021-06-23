//
//  GameBoardViewModel.swift
//  Fourteenth Clue
//
//  Created by Joseph Roque on 2021-06-22.
//

import Combine

class GameBoardViewModel: ObservableObject {

	@Published private(set) var state: GameState

	let solver: ClueSolver

	init(playerCount: Int) {
		let state = GameState(playerCount: playerCount)
		self.state = state
		self.solver = ClueSolver(initialState: state)
	}

	// View actions

	func onAppear() {
		print("Starting game with \(state.players.count) players")
	}
}
