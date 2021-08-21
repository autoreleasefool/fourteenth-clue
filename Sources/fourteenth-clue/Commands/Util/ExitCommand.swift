//
//  ExitCommand.swift
//  FourteenthClue
//
//  Created by Joseph Roque on 2021-08-17.
//

import ConsoleKit

struct ExitCommand: RunnableCommand {

	static var name: String {
		"exit"
	}

	static var shortName: String? {
		"e"
	}

	static var help: [ConsoleTextFragment] {
		[.init(string: "quit the program.", style: .error)]
	}

	private let exitCode: ExitCode
	private let message: String?

	init?(_ string: String) {
		guard string == "exit" || string == "e" else { return nil }
		self.exitCode = ExitCode.success
		self.message = nil
	}

	func run(_ state: EngineState) throws {
		if let message = message {
			state.context.console.output("\nExiting, \(message)", style: .error)
		}

		throw exitCode
	}
}
