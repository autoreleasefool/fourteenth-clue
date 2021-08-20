//
//  SolutionsCommand.swift
//  FourteenthCLue
//
//  Created by Joseph Roque on 2021-08-18.
//

struct SolutionsCommand: RunnableCommand {

	static var help: String {
		"""
		solutions [sol]: show most likely solutions. USAGE:
			- show <int> most likely solutions: solutions <int>
		"""
	}

	let limit: Int

	init?(_ string: String) {
		guard string.starts(with: "solutions") ||
						string == "sol" else { return nil }

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

		let solutions = limit >= 0
			? state.solutions.prefix(limit)
			: state.solutions[0...]

		solutions.enumerated()
			.forEach { index, solution in
				let ordinal = "\(index + 1)".padding(toLength: 2, withPad: " ", startingAt: 0)
				let probability = String(format: "%.2f", solution.probability)
				print("\(ordinal). [\(probability)%] - \(solution.person.name), \(solution.location.name), \(solution.weapon.name)")
			}
	}

}
