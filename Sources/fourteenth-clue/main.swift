//
//  main.swift
//  FourteenthClue
//
//  Created by Joseph Roque on 2021-08-18.
//

import ConsoleKit
import Foundation
import FourteenthClueKit

enum ExitCode: Int32, Error {

	case success = 0
	case failure = 1
	case validationFailure = 2

}

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
		guard signature.numberOfPlayers != nil || signature.initialState != nil else {
			throw ExitCode.validationFailure
		}

		guard !(signature.numberOfPlayers != nil && signature.initialState != nil) else {
			throw ExitCode.validationFailure
		}

		var state: GameState?

		if let numberOfPlayers = signature.numberOfPlayers {
			guard (2...6).contains(numberOfPlayers) else {
				throw ExitCode.validationFailure
			}
			state = GameState(playerCount: numberOfPlayers)
		}

		if let initialState = signature.initialState {
			guard let gameState = GameState(seed: initialState) else {
				throw ExitCode.validationFailure
			}
			state = gameState
		}

		guard let gameState = state else {
			throw ExitCode.validationFailure
		}

		let engine = Engine(state: gameState, context: context)
		engine.runLoop()
	}
}

let console: Console = Terminal()
var input = CommandInput(arguments: CommandLine.arguments)
var context = CommandContext(console: console, input: input)

var commands = Commands(enableAutocomplete: true)
commands.use(FourteenthClue(), as: "fourteenth-clue", isDefault: false)

do {
	let group = commands.group(help: "Play a game of 13 Clues.")
	try console.run(group, input: input)
} catch let error {
	console.error("\(error)")
	exit(1)
}

RunLoop.main.run()
