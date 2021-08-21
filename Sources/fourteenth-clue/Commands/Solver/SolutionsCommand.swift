//
//  SolutionsCommand.swift
//  FourteenthCLue
//
//  Created by Joseph Roque on 2021-08-18.
//

import ConsoleKit

struct SolutionsCommand: RunnableCommand {

	static var name: String {
		"solutions"
	}

	static var shortName: String? {
		"sol"
	}

	static var help: [ConsoleTextFragment] {
		[
			.init(string: "show most likely solutions."),
			.init(string: "\n  - show <int> most likely solutions: solutions <int>"),
		]
	}

	let limit: Int

	init?(_ string: String) {
		guard string.starts(with: "solutions") ||
						string.starts(with: "sol ") ||
						string == "sol" else { return nil }

		let components = string.components(separatedBy: " ")

		guard components.count <= 2 else { return nil }

		if components.count == 2 {
			guard let limit = Int(components[1]) else {
				return nil
			}

			self.limit = limit
		} else {
			self.limit = -1
		}
	}

	func run(_ state: EngineState) throws {
		guard state.gameState.isSolveable else {
			state.context.console.warning("Not enough information to solve yet.")
			return
		}

		guard !state.solutions.isEmpty else {
			let progress = state.solverProgress ?? 0
			let progressString = String(format: "%.2f", progress * 100)
			state.context.console.warning("Still calculating solution (\(progressString))...")
			return
		}

		let solutions = limit >= 0
			? state.solutions.prefix(limit)
			: state.solutions[0...]

		let output: [ConsoleTextFragment] = Array(
			solutions.enumerated()
				.flatMap { index, solution -> [ConsoleTextFragment] in
					let probability = String(format: "%.2f", solution.probability * 100)

					return [
						[.init(string: "\n")],
						[.init(string: "\(index + 1)".padding(toLength: 2, withPad: " ", startingAt: 0))],
						[.init(string: ". [\(probability)%] - ")],
						solution.person.name.consoleText(withState: state.gameState),
						[.init(string: ", ")],
						solution.location.name.consoleText(withState: state.gameState),
						[.init(string: ", ")],
						solution.weapon.name.consoleText(withState: state.gameState),
					].flatMap { $0 }
				}.dropFirst()
		)

		state.context.console.output(.init(fragments: output))
	}

}
