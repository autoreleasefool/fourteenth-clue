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
		print(states.count)
	}

}
