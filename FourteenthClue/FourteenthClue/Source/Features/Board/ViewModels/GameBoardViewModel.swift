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

	func setCard(_ card: Card?, forPlayer playerIndex: Int, atPosition position: CardPosition) {
		switch position {
		case .leftCard:
			state.players[playerIndex].privateCards.leftCard = card
		case .rightCard:
			state.players[playerIndex].privateCards.rightCard = card
		case .person:
			state.players[playerIndex].mystery.person = card
		case .location:
			state.players[playerIndex].mystery.location = card
		case .weapon:
			state.players[playerIndex].mystery.weapon = card
		}
	}

	func setCard(_ card: Card?, forInformant informant: Int) {
		state.secretInformants[informant] = card
	}
}
