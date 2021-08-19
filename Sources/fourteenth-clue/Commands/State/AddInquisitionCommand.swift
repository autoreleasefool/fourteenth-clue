//
//  AddInquisitionCommand.swift
//  FourteenthClue
//
//  Created by Joseph Roque on 2021-08-18.
//

import FourteenthClueKit

struct AddInquisitionCommand: RunnableCommand {

	static var help: String {
		"""
		add-inquisition [addi]: add a new inquisition. USAGE:
			- add an inquisition:
				add-inquisition <asking-player> <answering-player>
					<category> <count>
		"""
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

		print("Added action: \(action.description(withState: updatedState))" )
	}

}
