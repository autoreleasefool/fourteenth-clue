//
//  EngineState.swift
//  FourteenthClue
//
//  Created by Joseph Roque on 2021-08-18.
//

import FourteenthClueKit

class EngineState {

	private(set) var gameState: GameState
	private(set) var hasShownHelp: Bool
	private(set) var isRunning: Bool

	private(set) var possibleStates: [PossibleState]
	private(set) var solutions: [Solution]

	private var solver: MysterySolver = PossibleStateEliminationSolver()
	private var evaluator: InquiryEvaluator = BruteForceInquiryEvaluator()

	init(
		gameState: GameState,
		hasShownHelp: Bool = false,
		isRunning: Bool = true
	) {
		self.gameState = gameState
		self.hasShownHelp = hasShownHelp
		self.isRunning = isRunning
		self.solutions = []
		self.possibleStates = []

		solver.delegate = self
		evaluator.delegate = self
	}

	func updateState(to gameState: GameState) {
		self.gameState = gameState
		self.possibleStates = []
		solver.solve(state: gameState)
	}

	func didShowHelp() {
		hasShownHelp = true
	}

	func stop() {
		isRunning = false
	}

}

extension EngineState: PossibleStateEliminationSolverDelegate {

	func solver(_ solver: MysterySolver, didReturnSolutions solutions: [Solution]) {
		self.solutions = solutions
	}

	func solver(_ solver: MysterySolver, didEncounterError error: MysterySolverError) {
		// TODO: output error
		self.solutions = []
		self.possibleStates = []
	}

	func solver(_ solver: MysterySolver, didGeneratePossibleStates possibleStates: [PossibleState], for state: GameState) {
		guard state.id == self.gameState.id else { return }
		self.possibleStates = possibleStates
	}

}


extension EngineState: InquiryEvaluatorDelegate {

	func evaluator(_ evaluator: InquiryEvaluator, didFindOptimalInquiries inquiries: [Inquiry]) {

	}

	func evaluator(_ evaluator: InquiryEvaluator, didEncounterError error: InquiryEvaluatorError) {
		// TODO: output error
	}

}
