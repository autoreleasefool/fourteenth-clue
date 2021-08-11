//
//  PossibleStateEliminationSolver.swift
//  Fourteenth Clue
//
//  Created by Joseph Roque on 2021-07-04.
//

import Combine
import Foundation

class PossibleStateEliminationSolver: ClueSolver {

	private let subject: PassthroughSubject<[Solution], Never>

	init() {
		let subject = PassthroughSubject<[Solution], Never>()
		self.subject = subject
		super.init(solutionsSubject: subject)
	}

	override func solve(state: GameState) {
		guard state.id == self.state?.id else { return }

		var states = state.allPossibleStates()

		let stateCounts = states.reduce(into: [Solution:Int]()) { counts, possibleState in
			counts[possibleState.solution] = (counts[possibleState.solution] ?? 0) + 1
		}

		let solutions = stateCounts.map { key, value in
			Solution(
				person: key.person,
				location: key.location,
				weapon: key.weapon,
				probability: Double(value) / Double(states.count)
			)
		}

		subject.send(solutions.sorted())
	}

}
