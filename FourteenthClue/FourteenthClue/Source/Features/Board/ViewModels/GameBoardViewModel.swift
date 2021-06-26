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

	init(state: GameState) {
		self.state = state
		self.solver = ClueSolver(initialState: state)
	}

	// View actions

	func onAppear() {
		print("Starting game with \(state.players.count) players")
	}

	func setCard(_ card: Card?, forPlayer player: Int, atPosition position: CardPosition) {
		var player = state.players[player]
		switch position {
		case .leftCard:
			player.privateCards.leftCard = card
		case .rightCard:
			player.privateCards.rightCard = card
		case .person:
			player.mystery.person = card
		case .location:
			player.mystery.location = card
		case .weapon:
			player.mystery.weapon = card
		}

		// TODO: do I need to set the player back here?
		// state.players[player] = player
	}

	func setCard(_ card: Card?, forInformant informant: Int) {
		state.secretInformants[informant] = card
	}
}
