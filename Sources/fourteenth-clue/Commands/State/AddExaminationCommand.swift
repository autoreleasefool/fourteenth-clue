//
//  AddExaminationCommand.swift
//  FourteenthClue
//
//  Created by Joseph Roque on 2021-08-21.
//

import ConsoleKit
import FourteenthClueKit

struct AddExaminationCommand: RunnableCommand {

	static var name: String {
		"add-examination"
	}

	static var shortName: String? {
		"adde"
	}

	static var help: [ConsoleTextFragment] {
		[
			.init(string: "add a new examination."),
			.init(string: "\n  - add an examination: add-examination <player> <informant>"),
		]
	}

	let playerName: String
	let informantName: String

	init?(_ string: String) {
		guard string.starts(with: "add-examination") ||
						string.starts(with: "adde") else { return nil }

		let components = string.components(separatedBy: " ")
		guard components.count == 3 else { return nil }

		self.playerName = components[1]
		self.informantName = components[2]
	}

	func run(_ state: EngineState) throws {
		let examination = Examination(
			ordinal: state.gameState.actions.count,
			player: playerName,
			informant: informantName
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
