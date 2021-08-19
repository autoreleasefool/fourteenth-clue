//
//  SolutionsCommand.swift
//  FourteenthCLue
//
//  Created by Joseph Roque on 2021-08-18.
//

struct SolutionsCommand: RunnableCommand {

	static var help: String {
		"""
		solutions: show most likely solutions. USAGE:
			- show most likely solutions: solutions <int>
		"""
	}

	let limit: Int

	init?(_ string: String) {
		guard string.starts(with: "solutions") else { return nil }

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
		guard !state.solutions.isEmpty else {
			print("Still calculating solutions...")
			return
		}
	}

}
