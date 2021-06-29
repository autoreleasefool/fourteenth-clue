//
//  GameBoardViewModel.swift
//  Fourteenth Clue
//
//  Created by Joseph Roque on 2021-06-22.
//

import Combine
import Foundation

class GameBoardViewModel: ObservableObject {

	@Published var state: GameState {
		didSet {
			solver.state = state
		}
	}
	@Published var pickingSecretInformant: SecretInformant?
	@Published var addingClue = false
	@Published var showingSolutions = false
	@Published var possibleSolutions: [Solution] = []
	private var solutionsCancellable: AnyCancellable?

	let solver = ClueSolver()

	init(state: GameState) {
		self.state = state
	}

	// MARK: View actions

	func onAppear() {
		print("Starting game with \(state.players.count) players")
		solutionsCancellable = solver
			.solutions
			.receive(on: RunLoop.main)
			.sink { [weak self] solutions in
				self?.possibleSolutions = solutions
			}
	}

	func onDisappear() {
		solutionsCancellable = nil
	}

	func addClue() {
		addingClue = true
	}

	func showSolutions() {
		showingSolutions = true
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

	var unallocatedCards: Set<Card> {
		state.unallocatedCards
	}

	func player(withId id: UUID) -> GameState.Player? {
		state.players.first { $0.id == id }
	}

}
