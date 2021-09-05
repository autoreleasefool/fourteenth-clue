//
//  Engine.swift
//  FourteenthClue
//
//  Created by Joseph Roque on 2021-08-17.
//

import ConsoleKit
import Foundation
import FourteenthClueKit

class Engine {

	private let queue = DispatchQueue(label: "ca.josephroque.FourteenthClue.Engine")
	let state: EngineState

	init(state: GameState, context: CommandContext) {
		self.state = EngineState(gameState: state, context: context)
	}

	func runLoop() {
		queue.async {
			do {
				try self.playGame()
			} catch {
				if let exitCode = error as? ExitCode {
					exit(exitCode.errorCode)
				} else {
					exit(ExitCode.failure(reason: "\(error)").errorCode)
				}
			}
		}
	}

	func playGame() throws {
		guard state.isRunning else {
			throw ExitCode.success
		}

		var helpMessage = ""
		if !state.hasShownHelp {
			helpMessage = " (try typing 'help')"
			state.didShowHelp()
		}

		let command = state.context.console.ask("Enter a command\(helpMessage):".consoleText(.info))
		let commandToRun = parseCommand(string: command)
		try commandToRun.run(state)

		self.runLoop()
	}

}
