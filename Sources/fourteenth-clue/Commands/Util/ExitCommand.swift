//
//  ExitCommand.swift
//  FourteenthClue
//
//  Created by Joseph Roque on 2021-08-17.
//

import ArgumentParser

struct ExitCommand: RunnableCommand {

	static var help: String {
		"exit: quit the program."
	}

	private let exitCode: ExitCode
	private let message: String?

	init?(_ string: String) {
		guard string == "exit" else { return nil }
		self.exitCode = ExitCode.success
		self.message = nil
	}

	func run(_ state: EngineState) throws {
		if let message = message {
			print("\nExiting, \(message)")
		}

		throw exitCode
	}
}
