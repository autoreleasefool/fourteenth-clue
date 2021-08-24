//
//  SetPlayerCommand.swift
//  FourteenthClue
//
//  Created by Joseph Roque on 2021-08-17.
//

import ConsoleKit
import Foundation
import FourteenthClueKit

struct SetPlayerCommand: RunnableCommand {

	static var name: String {
			"set-player"
		}

		static var shortName: String? {
			"setp"
		}

	static var help: [ConsoleTextFragment] {
		let cardPositions = Card.Position.allCases.map { $0.rawValue }.joined(separator: "|")
		return [
			.init(string: "update a player's properties."),
			.init(string: "\n  - change player's name: set-player <name> name:<newName>"),
			.init(string: "\n  - change a player's cards: set-player <name> <\(cardPositions)>:<cardName>"),
		]
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
			self.modification = .changeName(toName: propertyChange[1])
		} else {
			guard let position = Card.Position(rawValue: propertyChange[0]),
						let card = Card(rawValue: propertyChange[1])
			else {
				return nil
			}

			self.modification = .changeCard(atPosition: position, toCard: card)
		}
	}

	func run(_ state: EngineState) throws {
		guard let player = state.gameState.players.first(where: { $0.name == playerName }),
					let playerIndex = state.gameState.players.firstIndex(of: player)
		else {
			return
		}

		let updatedPlayer: Player
		switch modification {
		case .changeName(let toName):
			updatedPlayer = player.with(name: toName)
		case .changeCard(let atPosition, let toCard):
			switch atPosition {
			case .hiddenLeft:
				updatedPlayer = player.withHiddenCard(onLeft: toCard)
			case .hiddenRight:
				updatedPlayer = player.withHiddenCard(onRight: toCard)
			case .person:
				updatedPlayer = player.withMysteryPerson(toCard)
			case .location:
				updatedPlayer = player.withMysteryLocation(toCard)
			case .weapon:
				updatedPlayer = player.withMysteryWeapon(toCard)
			}
		}

		let updatedState = state.gameState.with(player: updatedPlayer, atIndex: playerIndex)
		state.updateState(to: updatedState)

		state.context.console.output(.init(fragments: [
			[.init(string: "Updated ")],
			[playerName.highlighted],
			[.init(string: ", ")],
			modification.description.consoleText(withState: updatedState),
		].flatMap { $0 }))
	}

}

extension SetPlayerCommand {

	enum Modification: CustomStringConvertible {
		case changeName(toName: String)
		case changeCard(atPosition: Card.Position, toCard: Card)

		var description: String {
			switch self {
			case .changeName(let toCard):
				return "changed name to \(toCard)"
			case .changeCard(let atPosition, let toCard):
				return "changed \(atPosition) to \(toCard)"
			}
		}
	}

}
