//
//  ShowCommand.swift
//  FourteenthClue
//
//  Created by Joseph Roque on 2021-08-18.
//

import ConsoleKit

struct ShowCommand: RunnableCommand {

	static var name: String {
		"show"
	}

	static var shortName: String? {
		"s"
	}

	static var help: [ConsoleTextFragment] {
		[.init(string: "show the current state of the game.")]
	}

	static let unknown = "Unknown"

	init?(_ string: String) {
		guard string == "show" || string == "s" else { return nil }
	}

	func run(_ state: EngineState) throws {
		var output: [ConsoleTextFragment] = [
			.init(string: "Players", style: .success),
		]

		output.append(contentsOf: state.gameState.players.flatMap {
			[
				[.init(string: "\n  ")],
				[$0.name.highlighted],
				[.init(string: "\n    Mystery: ")],
				($0.mystery.person?.name ?? Self.unknown).consoleText(withState: state.gameState),
				[.init(string: ", ")],
				($0.mystery.location?.name ?? Self.unknown).consoleText(withState: state.gameState),
				[.init(string: ", ")],
				($0.mystery.weapon?.name ?? Self.unknown).consoleText(withState: state.gameState),
				[.init(string: "\n    Hidden: ")],
				($0.hidden.left?.name ?? Self.unknown).consoleText(withState: state.gameState),
				[.init(string: ", ")],
				($0.hidden.right?.name ?? Self.unknown).consoleText(withState: state.gameState),
			].flatMap { $0 }
		})

		if !state.gameState.secretInformants.isEmpty {
			output.append(.init(string: "\nInformants", style: .success))
			output.append(contentsOf: state.gameState.secretInformants.flatMap {
				"\n  \($0.name): \($0.card?.name ?? Self.unknown)".consoleText(withState: state.gameState)
			})
		}

		if !state.gameState.actions.isEmpty {
			output.append(.init(string: "\nActions", style: .success))
			output.append(contentsOf: state.gameState.actions.flatMap {
				"\n  \($0.description(withState: state.gameState))".consoleText(withState: state.gameState)
			})
		}

		state.context.console.output(.init(fragments: output))
	}
}
