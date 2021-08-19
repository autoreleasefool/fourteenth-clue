//
//  Command.swift
//  FourteenthClue
//
//  Created by Joseph Roque on 2021-08-17.
//

import ArgumentParser
import Foundation
import FourteenthClueKit

protocol RunnableCommand {
	static var help: String { get }

	init?(_ string: String)
	func run(_ state: EngineState) throws
}

let allCommandClasses: [RunnableCommand.Type] = [
	HelpCommand.self,
	SetPlayerCommand.self,
	SetInformantCommand.self,
	AddInquisitionCommand.self,
	AddAccusationCommand.self,
	OutputStateCommand.self,
	ExitCommand.self,
	// InvalidCommand.self, - do not include
]

func parseCommand(string: String) -> RunnableCommand {
	let firstRunnableCommand = allCommandClasses.firstNonNil { $0.init(string) }
	return firstRunnableCommand ?? InvalidCommand(string)
}
