import ArgumentParser
import FourteenthClueKit

struct FourteenthClue: ParsableCommand {

	@Option(help: "The state to seed the game with, from BoardGameArena.")
	var initialState: String?

	@Option(help: "The number of players in the game")
	var numberOfPlayers: Int?

	mutating func validate() throws {
		guard numberOfPlayers != nil || initialState != nil else {
			throw ValidationError("Please specify one of number of players, or initial state.")
		}

		guard !(numberOfPlayers != nil && initialState != nil) else {
			throw ValidationError("Please only specify number of players, or initial state.")
		}

		if let numberOfPlayers = numberOfPlayers {
			guard (2...6).contains(numberOfPlayers) else {
				throw ValidationError("Games must have between 2 and 6 players.")
			}
		}

		if let initialState = initialState {
			guard let _ = GameState(seed: initialState) else {
				throw ValidationError("Failed to parse state.")
			}
		}
	}

	mutating func run() throws {
		var state: GameState?
		if let numberOfPlayers = numberOfPlayers {
			state = GameState(playerCount: numberOfPlayers)
		} else if let initialState = initialState {
			state = GameState(seed: initialState)
		}

		guard let gameState = state else {
			throw ExitCode.validationFailure
		}

		var engine = Engine(state: gameState)
		try engine.playGame()
	}

}

FourteenthClue.main()
