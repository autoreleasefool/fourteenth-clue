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

	var solver: ClueSolver = SolutionEliminationSolver()

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

	func setCard(_ card: Card?, forPlayer player: Player, atPosition position: CardPosition) {
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

	func setCard(_ card: Card?, forInformant informant: SecretInformant) {
		state = state.withSecretInformant(informant.withCard(card))
	}

	func addClue(_ clue: AnyClue) {
		state = state.addingClue(clue)
	}

	func deleteClues(atOffsets offsets: IndexSet) {
		state = state.removingClues(atOffsets: offsets)
	}

	var secretInformants: [(String, SecretInformant)] {
		zip("ABCDEFGH", state.secretInformants)
			.map { name, informant in (String(name), informant) }
	}

	var players: [Player] {
		state.players
	}

	var clues: [AnyClue] {
		state.clues
	}

	var unallocatedCards: Set<Card> {
		state.unallocatedCards
	}

	func player(withId id: String) -> Player? {
		state.players.first { $0.id == id }
	}

}
