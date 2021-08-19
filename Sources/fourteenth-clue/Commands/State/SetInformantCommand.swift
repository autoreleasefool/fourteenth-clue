//
//  SetInformantCommand.swift
//  FourteenthClue
//
//  Created by Joseph Roque on 2021-08-18.
//

import FourteenthClueKit

struct SetInformantCommand: RunnableCommand {

	static var help: String {
		"""
		set-informant [seti]: update an informant's properties. USAGE:
			- set the card for an informant: set-informant <name> <card>
		"""
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

	func run(_ state: EngineState) throws -> EngineState {
		let informant = SecretInformant(name: informantName, card: card)
		let updatedState = state.gameState.with(secretInformant: informant)

		print("Updated \(informantName), replaced card with \(card?.name ?? "none")")

		return state.with(gameState: updatedState)
	}

}
