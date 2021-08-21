//
//  Engine.swift
//  FourteenthClue
//
//  Created by Joseph Roque on 2021-08-17.
//

import ArgumentParser
import Foundation
import FourteenthClueKit

class Engine {

	private let queue = DispatchQueue(label: "ca.josephroque.FourteenthClue.Engine")
	let initialState: EngineState
	var currentState: EngineState

	init(state: GameState) {
		self.initialState = EngineState(gameState: state)
		self.currentState = self.initialState
	}

	func runLoop() {
		queue.async {
			do {
				try self.playGame()
			} catch {
				if let exitCode = error as? ExitCode {
					exit(exitCode.rawValue)
				} else {
					exit(ExitCode.failure.rawValue)
				}
			}
		}
	}

	func playGame() throws {
		guard currentState.isRunning else {
			throw ExitCode.success
		}

		var helpMessage = ""
		if !currentState.hasShownHelp {
			helpMessage = " (try typing 'help')"
			currentState.didShowHelp()
		}

		print("Command\(helpMessage): ", terminator: "")
		guard let rawCommand = readLine() else { return }

		let commandToRun = parseCommand(string: rawCommand.trimmingCharacters(in: .whitespacesAndNewlines))
		try commandToRun.run(currentState)

		self.runLoop()
	}

}
