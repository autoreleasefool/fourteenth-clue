//
//  Engine.swift
//  FourteenthClue
//
//  Created by Joseph Roque on 2021-08-17.
//

import ArgumentParser
import Foundation
import FourteenthClueKit

struct Engine {

	let initialState: EngineState
	var currentState: EngineState

	init(state: GameState) {
		self.initialState = EngineState(gameState: state)
		self.currentState = self.initialState
	}

	mutating func playGame() throws {
		while currentState.isRunning {

			var helpMessage = ""
			if !currentState.hasShownHelp {
				helpMessage = " (try typing 'help')"
				currentState.didShowHelp()
			}

			print("Command\(helpMessage): ", terminator: "")
			guard let rawCommand = readLine() else { return }

			let commandToRun = parseCommand(string: rawCommand.trimmingCharacters(in: .whitespacesAndNewlines))
			try commandToRun.run(currentState)
		}
	}

}
