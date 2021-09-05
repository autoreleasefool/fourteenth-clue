//
//  main.swift
//  FourteenthClue
//
//  Created by Joseph Roque on 2021-08-18.
//

import ConsoleKit
import Foundation
import FourteenthClueKit

enum ExitCode: LocalizedError {

	case success
	case failure(reason: String)
	case validationFailure(reason: String)

	var errorDescription: String? {
		switch self {
		case .success:
			return "No failures."
		case .failure(let reason), .validationFailure(let reason):
			return reason
		}
	}

	var errorCode: Int32 {
		switch self {
		case .success:
			return 0
		case .failure:
			return 1
		case .validationFailure:
			return 2
		}
	}

}

let console: Console = Terminal()
var input = CommandInput(arguments: CommandLine.arguments)
var context = CommandContext(console: console, input: input)

var commands = Commands(enableAutocomplete: true)
commands.use(FourteenthClue(), as: "fourteenth-clue", isDefault: true)

do {
	let group = commands.group(help: "Play a game of 13 Clues.")
	try console.run(group, input: input)
} catch let error {
	console.error("\(error)")
	exit(1)
}

RunLoop.main.run()
