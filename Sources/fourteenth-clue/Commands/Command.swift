//
//  Command.swift
//  FourteenthClue
//
//  Created by Joseph Roque on 2021-08-17.
//

import ConsoleKit
import Foundation
import FourteenthClueKit

protocol RunnableCommand {
	static var name: String { get }
	static var shortName: String? { get }
	static var help: [ConsoleTextFragment] { get }

	init?(_ string: String)
	func run(_ state: EngineState) throws
	static func buildHelp() -> [ConsoleTextFragment]
}

extension RunnableCommand {

	static func buildHelp() -> [ConsoleTextFragment] {
		[
			.init(string: "\(name)", style: .info),
			shortName != nil ? .init(string: " [\(shortName!)]: ", style: .init(isBold: true)) : .init(string: ": "),
		] + help
	}

}

let allCommandClasses: [RunnableCommand.Type] = [
	HelpCommand.self,
	SetPlayerCommand.self,
	SetInformantCommand.self,
	AddInquisitionCommand.self,
	AddAccusationCommand.self,
	AddExaminationCommand.self,
	SolutionsCommand.self,
	InquiriesCommand.self,
	OutputStateCommand.self,
	ExitCommand.self,
	// InvalidCommand.self, - do not include
]

func parseCommand(string: String) -> RunnableCommand {
	let firstRunnableCommand = allCommandClasses.firstNonNil { $0.init(string) }
	return firstRunnableCommand ?? InvalidCommand(string)
}
