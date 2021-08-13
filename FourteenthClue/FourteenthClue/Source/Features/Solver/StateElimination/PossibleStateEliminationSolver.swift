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

	private var possibleStatesCache: [PossibleState]?

	init() {
		let subject = PassthroughSubject<[Solution], Never>()
		self.subject = subject
		super.init(solutionsSubject: subject)
	}

	override func solve(state: GameState, prevState: GameState?) {
		let reporter = StepReporter()
		guard state.id == self.state?.id else { return }

		let shouldCancelEarly = { [weak self] in
			state.id != self?.state?.id
		}

		if let prevState = prevState,
			 shouldClearStateCache(prevState: prevState, nextState: state) {
			possibleStatesCache = nil
		}

		reporter.reportStep(message: "Beginning state generation")

		var states = possibleStatesCache ?? state.allPossibleStates(shouldCancel: shouldCancelEarly)
		reporter.reportStep(message: "Finished generating states")

		var clues = state.clues

		resolveMyAccusations(state, &clues, &states, shouldCancelEarly)
		reporter.reportStep(message: "Finished resolving my accusations")

		resolveOpponentAccusations(state, &clues, &states, shouldCancelEarly)
		reporter.reportStep(message: "Finished resolving opponent accusations")

		resolveInquisitionsInIsolation(state, &clues, &states, shouldCancelEarly)
		reporter.reportStep(message: "Finished resolving inquisitions in isolation")

		resolveInquisitionsInCombination(state, &clues, &states, shouldCancelEarly)
		reporter.reportStep(message: "Finished resolving inquisitions in combination")

		let solutions = processStatesIntoSolutions(states)
		guard state.id == self.state?.id else { return }

		reporter.reportStep(message: "Finished generating \(states.count) possible states.")
		possibleStatesCache = states
		subject.send(solutions.sorted())
	}

	private func resolveMyAccusations(
		_ state: GameState,
		_ clues: inout [AnyClue],
		_ possibleStates: inout [PossibleState],
		_ shouldCancelEarly: () -> Bool
	) {
	}

	private func resolveOpponentAccusations(
		_ state: GameState,
		_ clues: inout [AnyClue],
		_ possibleStates: inout [PossibleState],
		_ shouldCancelEarly: () -> Bool
	) {
	}

	private func resolveInquisitionsInIsolation(
		_ state: GameState,
		_ clues: inout [AnyClue],
		_ possibleStates: inout [PossibleState],
		_ shouldCancelEarly: () -> Bool
	) {
	}

	private func resolveInquisitionsInCombination(
			_ state: GameState,
			_ clues: inout [AnyClue],
			_ possibleStates: inout [PossibleState],
			_ shouldCancelEarly: () -> Bool
		) {
		}

	private func processStatesIntoSolutions(_ states: [PossibleState]) -> [Solution] {
		states.reduce(into: [Solution:Int]()) { counts, possibleState in
			counts[possibleState.solution] = (counts[possibleState.solution] ?? 0) + 1
		}.map { key, value in
			Solution(
				person: key.person,
				location: key.location,
				weapon: key.weapon,
				probability: Double(value) / Double(states.count)
			)
		}
	}

	private func shouldClearStateCache(prevState: GameState, nextState: GameState) -> Bool {
		!prevState.isEarlierState(of: nextState)
	}

}
