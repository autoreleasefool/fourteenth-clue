//
//  GameState+Extensions.swift
//  FourteenthClue
//
//  Created by Joseph Roque on 2021-08-19.
//

import FourteenthClueKit

extension Player {

	func isSolveable(asFirstPlayer: Bool) -> Bool {
		if asFirstPlayer {
			return hidden.left != nil && hidden.right != nil
		} else {
			return mystery.isComplete
		}
	}
}

extension GameState {

	var isSolveable: Bool {
		players.first!.isSolveable(asFirstPlayer: true) &&
			players.dropFirst().allSatisfy { $0.isSolveable(asFirstPlayer: false) }
	}

}
