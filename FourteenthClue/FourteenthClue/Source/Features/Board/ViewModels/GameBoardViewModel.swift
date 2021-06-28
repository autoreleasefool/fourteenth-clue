//
//  GameBoardViewModel.swift
//  Fourteenth Clue
//
//  Created by Joseph Roque on 2021-06-22.
//

import Combine

class GameBoardViewModel: ObservableObject {

	@Published var state: GameState
	@Published var pickingSecretInformant: SecretInformant?

	let solver: ClueSolver

	init(state: GameState) {
		self.state = state
		self.solver = ClueSolver(initialState: state)
	}

	// MARK: View actions

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

	// MARK: Properties

	struct SecretInformant: Identifiable, CustomStringConvertible {
		let id: String
		let index: Int
		let card: Card?

		var description: String {
			if let card = card {
				return "\(id) - \(card)"
			} else {
				return "\(id) - ?"
			}
		}
	}

	var secretInformants: [SecretInformant] {
		zip("ABCDEFGH", state.secretInformants).enumerated().map { index, idAndInformant in
			let (id, informant) = idAndInformant
			return SecretInformant(id: String(id), index: index, card: informant)
		}
	}

	var players: [GameState.Player] {
		state.players
	}

	var clues: [Clue] {
		state.clues
	}

	var availableCards: [Card] {
		state.availableCards
	}

}
