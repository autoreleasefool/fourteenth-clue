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
			.init(string: """
				\n  - add an inquisition: add-inquisition \
				<asking-player> <answering-player> <category> <left|right|?> <count>
				"""),
		]
	}

	let askingPlayerName: String
	let answeringPlayerName: String
	let filter: Card.Filter
	let includingCardOnSide: Card.HiddenCardPosition?
	let count: Int

	init?(_ string: String) {
		guard string.starts(with: "add-inquisition") ||
						string.starts(with: "addi") else { return nil }

		let components = string.components(separatedBy: " ")

		let parsedFilter: Card.Filter?
		let includingCardOnSide: Card.HiddenCardPosition?
		let parsedCount: Int?

		if components.count == 5 {
			parsedFilter = Card.Filter(rawValue: components[3])
			includingCardOnSide = nil
			parsedCount = Int(components[4])
		} else if components.count == 6 {
			parsedFilter = Card.Filter(rawValue: components[3])
			includingCardOnSide = Card.HiddenCardPosition(rawValue: components[4])
			parsedCount = Int(components[5])
		} else {
			return nil
		}

		guard let filter = parsedFilter, let count = parsedCount else {
			return nil
		}

		self.askingPlayerName = components[1]
		self.answeringPlayerName = components[2]
		self.filter = filter
		self.includingCardOnSide = includingCardOnSide
		self.count = count
	}

	func run(_ state: EngineState) throws {
		guard (state.gameState.numberOfPlayers == 2 && includingCardOnSide != nil) ||
						(state.gameState.numberOfPlayers > 2 && includingCardOnSide == nil) else {
			return
		}

		let inquisition = Inquisition(
			ordinal: state.gameState.actions.count,
			askingPlayer: askingPlayerName,
			answeringPlayer: answeringPlayerName,
			filter: filter,
			includingCardOnSide: includingCardOnSide,
			count: count
		)

		let action: Action = .inquire(inquisition)
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
