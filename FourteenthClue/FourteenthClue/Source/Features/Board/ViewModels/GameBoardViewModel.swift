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

	func setCard(_ card: Card?, forPlayer index: Int, atPosition position: GameState.CardPosition) {
		switch position {
		case .leftCard:
			state = state.withPlayer(state.players[index].withPrivateCard(onLeft: card), at: index)
		case .rightCard:
			state = state.withPlayer(state.players[index].withPrivateCard(onRight: card), at: index)
		case .person:
			state = state.withPlayer(state.players[index].withMysteryPerson(card), at: index)
		case .location:
			state = state.withPlayer(state.players[index].withMysteryLocation(card), at: index)
		case .weapon:
			state = state.withPlayer(state.players[index].withMysteryWeapon(card), at: index)
		}
	}

	func setCard(_ card: Card?, forInformant informant: Int) {
		state = state.withSecretInformant(card, at: informant)
	}
}
