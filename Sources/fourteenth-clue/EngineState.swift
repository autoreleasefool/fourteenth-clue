//
//  EngineState.swift
//  FourteenthClue
//
//  Created by Joseph Roque on 2021-08-18.
//

import FourteenthClueKit

struct EngineState {

	let gameState: GameState
	let hasShownHelp: Bool
	let isRunning: Bool

	init(
		gameState: GameState,
		hasShownHelp: Bool = false,
		isRunning: Bool = true
	) {
		self.gameState = gameState
		self.hasShownHelp = hasShownHelp
		self.isRunning = isRunning
	}

	func with(gameState: GameState) -> EngineState {
		.init(gameState: gameState, hasShownHelp: hasShownHelp, isRunning: isRunning)
	}

	func didShowHelp() -> EngineState {
		.init(gameState: gameState, hasShownHelp: true, isRunning: isRunning)
	}

	func stop() -> EngineState {
		.init(gameState: gameState, hasShownHelp: hasShownHelp, isRunning: isRunning)
	}
}
