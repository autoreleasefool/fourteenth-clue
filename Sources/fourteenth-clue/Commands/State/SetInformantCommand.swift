//
//  SetInformantCommand.swift
//  FourteenthClue
//
//  Created by Joseph Roque on 2021-08-18.
//

import ConsoleKit
import FourteenthClueKit

struct SetInformantCommand: RunnableCommand {

	static var name: String {
		"set-informant"
	}

	static var shortName: String? {
		"seti"
	}

	static var help: [ConsoleTextFragment] {
		[
			.init(string: "update an informant's properties"),
			.init(string: "\n  - set the card for an informant: set-informant <name> <card>"),
		]
	}

	let informantName: String
	let card: Card?

	init?(_ string: String) {
		guard string.starts(with: "set-informant") ||
						string.starts(with: "seti") else { return nil }

		let components = string.components(separatedBy: " ")
		guard components.count == 3 else { return nil }

		self.informantName = components[1]
		self.card = Card(rawValue: components[2])
	}

	func run(_ state: EngineState) throws {
		let informant = SecretInformant(name: informantName, card: card)
		let updatedState = state.gameState.with(secretInformant: informant)
		state.updateState(to: updatedState)

		state.context.console.output(.init(fragments: [
			[.init(string: "Updated ")],
			[informantName.highlighted],
			[.init(string: ", replaced card with ")],
			card != nil ? card!.name.consoleText(withState: updatedState) : [.init(string: "none", style: .init(isBold: true))],
		].flatMap { $0 }))
	}

}
