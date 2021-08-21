//
//  HelpCommand.swift
//  FourteenthClue
//
//  Created by Joseph Roque on 2021-08-17.
//

import ConsoleKit

struct HelpCommand: RunnableCommand {

	static var name: String {
		"help"
	}

	static var shortName: String? {
		"h"
	}

	static var help: [ConsoleTextFragment] {
		[.init(string: "print all the available commands.")]
	}

	init?(_ string: String) {
		guard string == "help" || string == "h" else { return nil }
	}

	func run(_ state: EngineState) throws {
		allCommandClasses.forEach {
			state.context.console.output(.init(fragments: $0.buildHelp()))
		}
	}

}
