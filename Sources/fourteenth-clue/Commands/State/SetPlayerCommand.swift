//
//  SetPlayerCommand.swift
//  FourteenthClue
//
//  Created by Joseph Roque on 2021-08-17.
//

import Foundation
import FourteenthClueKit

struct SetPlayerCommand: RunnableCommand {

	static var help: String {
		let cardPositions = Card.Position.allCases.map { $0.rawValue }.joined(separator: "|")

		return """
		set-player [setp]: update a player's properties. USAGE:
			- change player's name: set-player <name> name:newName
			- change a player's cards: set-player <name> <\(cardPositions)>:cardName
		"""
	}

	let playerName: String
	let modification: Modification

	init?(_ string: String) {
		guard string.starts(with: "set-player") ||
						string.starts(with: "setp") else { return nil }

		let components = string.components(separatedBy: " ")
		guard components.count == 3 else { return nil }

		self.playerName = components[1]

		let propertyChange = components[2].components(separatedBy: ":")
		guard propertyChange.count == 2 else { return nil }

		if propertyChange[0] == "name" {
			self.modification = .changeName(to: propertyChange[1])
		} else {
			guard let position = Card.Position(rawValue: propertyChange[0]),
						let card = Card(rawValue: propertyChange[1])
			else {
				return nil
			}

			self.modification = .changeCard(at: position, to: card)
		}
	}

	func run(_ state: EngineState) throws -> EngineState {
		guard let player = state.gameState.players.first(where: { $0.name == playerName }),
					let playerIndex = state.gameState.players.firstIndex(of: player)
		else {
			return state
		}

		let updatedPlayer: Player
		switch modification {
		case .changeName(let to):
			updatedPlayer = player.with(name: to)
		case .changeCard(let at, let to):
			switch at {
			case .hiddenLeft:
				updatedPlayer = player.withHiddenCard(onLeft: to)
			case .hiddenRight:
				updatedPlayer = player.withHiddenCard(onRight: to)
			case .person:
				updatedPlayer = player.withMysteryPerson(to)
			case .location:
				updatedPlayer = player.withMysteryLocation(to)
			case .weapon:
				updatedPlayer = player.withMysteryWeapon(to)
			}
		}

		let updatedState = state.gameState.with(player: updatedPlayer, atIndex: playerIndex)
		return state.with(gameState: updatedState)
	}

}

extension SetPlayerCommand {

	enum Modification {
		case changeName(to: String)
		case changeCard(at: Card.Position, to: Card)
	}

}
