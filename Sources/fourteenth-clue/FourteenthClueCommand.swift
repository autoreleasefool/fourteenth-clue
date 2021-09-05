//
//  FourteenthClueCommand.swift
//  FourteenthClue
//
//  Created by Joseph Roque on 2021-09-04.
//

import ConsoleKit
import FourteenthClueKit

struct FourteenthClue: Command {
	struct Signature: CommandSignature {
		@Option(name: "initial-state", short: "i", help: "Pass an initial seed state")
		var initialState: String?

		@Option(name: "number-of-players", short: "p", help: "Set a number of players")
		var numberOfPlayers: Int?
	}

	var help: String {
		"Play a game of 13 Clues, with a little help."
	}

	func run(using context: CommandContext, signature: Signature) throws {
		guard !(signature.numberOfPlayers != nil && signature.initialState != nil) else {
			throw ExitCode.validationFailure(reason: "Only one of initial state of number of players can be given")
		}

		let numberOfPlayers = signature.numberOfPlayers ?? 2
		let initialState = signature.initialState

		var state: GameState?

		if let initialState = initialState {
			guard let gameState = GameState(seed: initialState) else {
				throw ExitCode.validationFailure(reason: "Invalid initial state")
			}
			state = gameState
		} else {
			guard (2...6).contains(numberOfPlayers) else {
				throw ExitCode.validationFailure(reason: "Only supports 2-6 players")
			}
			state = GameState(playerCount: numberOfPlayers)
		}

		guard let gameState = state else {
			throw ExitCode.validationFailure(reason: "Initial state could not be defined")
		}

		context.console.output("Starting new game with \(gameState.numberOfPlayers) players", style: .success)
		let engine = Engine(state: gameState, context: context)
		engine.runLoop()
	}
}
