//
//  InvalidCommand.swift
//  FourteenthClue
//
//  Created by Joseph Roque on 2021-08-17.
//

import ConsoleKit

struct InvalidCommand: RunnableCommand {

	static var name: String {
		""
	}

	static var shortName: String? {
		nil
	}

	static var help: [ConsoleTextFragment] {
		[]
	}

	let command: String

	init(_ command: String) {
		self.command = command
	}

	func run(_ state: EngineState) throws {
		state.context.console.output(.init(fragments: [
			.init(string: "\(command)", style: .init(isBold: true)),
			.init(string: " is not a valid command", style: .error),
			.init(string: " (try typing 'help')", style: .info),
		]))
	}

}
