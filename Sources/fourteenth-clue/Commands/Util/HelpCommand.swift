//
//  HelpCommand.swift
//  FourteenthClue
//
//  Created by Joseph Roque on 2021-08-17.
//

struct HelpCommand: RunnableCommand {

	static var help: String {
		"help [h]: print all the available commands."
	}

	init?(_ string: String) {
		guard string == "help" || string == "h" else { return nil }
	}

	func run(_ state: EngineState) throws {
		allCommandClasses.forEach {
			print($0.help)
		}
	}

}
