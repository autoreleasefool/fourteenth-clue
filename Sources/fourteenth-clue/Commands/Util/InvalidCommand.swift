//
//  InvalidCommand.swift
//  FourteenthClue
//
//  Created by Joseph Roque on 2021-08-17.
//

struct InvalidCommand: RunnableCommand {

	static var help: String {
		"Invalid command. You shouldn't be seeing this."
	}

	let command: String

	init(_ command: String) {
		self.command = command
	}

	func run(_ state: EngineState) throws {
		print("`\(command)` is not a valid command (try typing `help`)")
	}

}
