//
//  AddAccusationCommand.swift
//  FourteenthClue
//
//  Created by Joseph Roque on 2021-08-18.
//

import FourteenthClueKit

struct AddAccusationCommand: RunnableCommand {

	static var help: String {
		"""
		add-accusation [adda]: add a new accusation. USAGE:
			- add an accusation:
				add-accusation <player> <person> <location> <weapon>
		"""
	}

	let playerName: String
	let person: Card
	let location: Card
	let weapon: Card

	init?(_ string: String) {
		guard string.starts(with: "add-accusation") ||
						string.starts(with: "adda") else { return nil }

		let components = string.components(separatedBy: " ")
		guard components.count == 5 else { return nil }

		self.playerName = components[1]

		guard let person = Card(rawValue: components[2]),
					let location = Card(rawValue: components[3]),
					let weapon = Card(rawValue: components[4])
		else {
			return nil
		}

		self.person = person
		self.location = location
		self.weapon = weapon
	}

	func run(_ state: EngineState) throws -> EngineState {
		let accusation = Accusation(
			ordinal: state.gameState.actions.count,
			accusingPlayer: playerName,
			accusation: .init(person: person, location: location, weapon: weapon)
		)

		let action = AnyAction(accusation)
		let updatedState = state.gameState.appending(action: action)
		return state.with(gameState: updatedState)
	}

}
