//
//  GameBuilderViewModel.swift
//  GameBuilderViewModel
//
//  Created by Joseph Roque on 2021-08-17.
//

import SwiftUI
import FourteenthClueKit

class GameBuilderViewModel: ObservableObject {

	var playerCount: Int
	@Published var playerNames: [String]
	@Published var intermediateState: GameState?
	@Published var gameState: GameState?
	@Published var initialJSONState = ""

	init(playerCount: Int) {
		self.playerCount = playerCount
		self.playerNames = (0..<playerCount).map { "Player-\($0 + 1)" }
	}

	func getTitle(forPlayer index: Int) -> String {
		"Player \(index + 1)"
	}

	func startGame() {
		if initialJSONState.isEmpty {
			gameState = GameState(playerNames: playerNames)
		} else {
			var state = GameState(seed: initialJSONState)!
			state.players.enumerated()
				.forEach { state = state.with(player: $0.element.with(name: playerNames[$0.offset]), atIndex: $0.offset) }
			gameState = state
		}
	}

	func formatJSON() {
		guard let data = initialJSONState.drop(while: { $0 != "{" }).data(using: .utf8),
					let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers),
					let pretty = try? JSONSerialization.data(withJSONObject: json, options: [.sortedKeys, .prettyPrinted]),
					let formatted = String(bytes: pretty, encoding: .utf8),
					let state = GameState(seed: formatted)
		else {
			return
		}

		DispatchQueue.main.async {
			self.playerNames = state.players.map { $0.name }
			self.initialJSONState = formatted
			self.intermediateState = state
		}
	}
}
