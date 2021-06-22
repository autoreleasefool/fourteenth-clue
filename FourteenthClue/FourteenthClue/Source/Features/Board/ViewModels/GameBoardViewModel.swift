//
//  GameBoardViewModel.swift
//  Fourteenth Clue
//
//  Created by Joseph Roque on 2021-06-22.
//

import Combine

class GameBoardViewModel: ObservableObject {

	let playerCount: Int

	init(playerCount: Int) {
		self.playerCount = playerCount
	}

	// View actions

	func onAppear() {
		print("Starting game with \(playerCount) players")
	}
}
