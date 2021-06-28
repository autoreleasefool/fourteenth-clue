//
//  GameBoardViewModel.swift
//  Fourteenth Clue
//
//  Created by Joseph Roque on 2021-06-22.
//

import Combine
import Foundation

class GameBoardViewModel: ObservableObject {

	@Published var state: GameState
	@Published var pickingSecretInformant: SecretInformant?
	@Published var addingClue: Bool = false

	let solver: ClueSolver

	init(state: GameState) {
		self.state = state
		self.solver = ClueSolver(initialState: state)
	}

	// MARK: View actions

	func onAppear() {
		print("Starting game with \(state.players.count) players")
	}

	func setCard(_ card: Card?, forPlayer player: GameState.Player, atPosition position: GameState.CardPosition) {
		switch position {
		case .leftCard:
			state = state.withPlayer(player.withPrivateCard(onLeft: card))
		case .rightCard:
			state = state.withPlayer(player.withPrivateCard(onRight: card))
		case .person:
			state = state.withPlayer(player.withMysteryPerson(card))
		case .location:
			state = state.withPlayer(player.withMysteryLocation(card))
		case .weapon:
			state = state.withPlayer(player.withMysteryWeapon(card))
		}
	}

	func setCard(_ card: Card?, forInformant informant: GameState.SecretInformant) {
		state = state.withSecretInformant(informant.withCard(card))
	}

	func addClue(_ clue: GameState.Clue) {
		state = state.addingClue(clue)
	}

	func deleteClues(atOffsets offsets: IndexSet) {
		state = state.removingClues(atOffsets: offsets)
	}

	// MARK: Properties

	struct SecretInformant: Identifiable, CustomStringConvertible {

		let id: String
		let informant: GameState.SecretInformant

		var description: String {
			if let card = informant.card {
				return "\(id) - \(card)"
			} else {
				return "\(id) - ?"
			}
		}

	}

	var secretInformants: [SecretInformant] {
		zip("ABCDEFGH", state.secretInformants).enumerated().map { index, nameAndInformant in
			let (name, informant) = nameAndInformant
			return SecretInformant(id: String(name), informant: informant)
		}
	}

	var players: [GameState.Player] {
		state.players
	}

	var clues: [GameState.Clue] {
		state.clues
	}

	var availableCards: Set<Card> {
		state.availableCards
	}

	func player(withId id: UUID) -> GameState.Player? {
		state.players.first { $0.id == id }
	}

}
