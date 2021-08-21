//
//  AddInquisitionCommand.swift
//  FourteenthClue
//
//  Created by Joseph Roque on 2021-08-18.
//

import ConsoleKit
import FourteenthClueKit

struct AddInquisitionCommand: RunnableCommand {

	static var name: String {
		"add-inquisition"
	}

	static var shortName: String? {
		"addi"
	}

	static var help: [ConsoleTextFragment] {
		[
			.init(string: "add a new inquisition."),
			.init(string: "\n  - add an inquisition: add-inquisition <asking-player> <answering-player> <category> <count>"),
		]
	}

	let askingPlayerName: String
	let answeringPlayerName: String
	let filter: Card.Filter
	let count: Int

	init?(_ string: String) {
		guard string.starts(with: "add-inquisition") ||
						string.starts(with: "addi") else { return nil }

		let components = string.components(separatedBy: " ")
		guard components.count == 5 else { return nil }

		guard let filter = Card.Filter(rawValue: components[3]),
					let count = Int(components[4]) else {
			return nil
		}

		self.askingPlayerName = components[1]
		self.answeringPlayerName = components[2]
		self.count = count
		self.filter = filter
	}

	func run(_ state: EngineState) throws {
		let inquisition = Inquisition(
			ordinal: state.gameState.actions.count,
			askingPlayer: askingPlayerName,
			answeringPlayer: answeringPlayerName,
			filter: filter,
			count: count
		)

		let action = AnyAction(inquisition)
		let updatedState = state.gameState.appending(action: action)
		state.updateState(to: updatedState)

		state.context.console.output(
			.init(
				fragments: [.init(string: "Added action:", style: .init(isBold: true))] +
					action.description(withState: updatedState).consoleText(withState: updatedState)
			)
		)
	}

}
