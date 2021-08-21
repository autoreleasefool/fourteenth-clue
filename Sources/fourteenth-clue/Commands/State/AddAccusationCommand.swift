//
//  AddAccusationCommand.swift
//  FourteenthClue
//
//  Created by Joseph Roque on 2021-08-18.
//

import ConsoleKit
import FourteenthClueKit

struct AddAccusationCommand: RunnableCommand {

	static var name: String {
		"add-accusation"
	}

	static var shortName: String? {
		"adda"
	}

	static var help: [ConsoleTextFragment] {
		[
			.init(string: "add a new accusation."),
			.init(string: "\n  - add an accusation: add-accusation <player> <person> <location> <weapon>"),
		]
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

	func run(_ state: EngineState) throws {
		let accusation = Accusation(
			ordinal: state.gameState.actions.count,
			accusingPlayer: playerName,
			accusation: .init(person: person, location: location, weapon: weapon)
		)

		let action = AnyAction(accusation)
		let updatedState = state.gameState.appending(action: action)
		state.updateState(to: updatedState)

		state.context.console.output(
			.init(
				fragments: "Added action: \(action.description(withState: updatedState))".consoleText(withState: state.gameState)
			)
		)
	}

}
