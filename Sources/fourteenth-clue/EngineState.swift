//
//  EngineState.swift
//  FourteenthClue
//
//  Created by Joseph Roque on 2021-08-18.
//

import ConsoleKit
import Foundation
import FourteenthClueKit

class EngineState: SolverDelegate {

	private(set) var gameState: GameState {
		didSet {
			self.solutions = []
			self.possibleStates = []
			self.optimalInquiries = []
		}
	}
	let context: CommandContext
	private(set) var hasShownHelp: Bool
	private(set) var isRunning: Bool

	private(set) var solutions: [Solution]
	private(set) var possibleStates: [PossibleState]
	private(set) var optimalInquiries: [Inquiry]

	private var solver = Solver()

	init(
		gameState: GameState,
		context: CommandContext,
		hasShownHelp: Bool = false,
		isRunning: Bool = true
	) {
		self.gameState = gameState
		self.context = context
		self.hasShownHelp = hasShownHelp
		self.isRunning = isRunning
		self.solutions = []
		self.possibleStates = []
		self.optimalInquiries = []

		self.solver.delegate = self
	}

	func updateState(to gameState: GameState) {
		self.gameState = gameState

		guard gameState.isSolveable else { return }
		solver.startSolving(state: gameState)
	}

	func didShowHelp() {
		hasShownHelp = true
	}

	func stop() {
		isRunning = false
		solver.cancel()
	}

	var solverProgress: Double? {
		solver.solverProgress
	}

	var evaluatorProgress: Double? {
		solver.evaluatorProgress
	}

}

// MARK: PossibleStateEliminationSolverDelegate

extension EngineState: PossibleStateEliminationSolverDelegate {

	func solver(_ solver: MysterySolver, didReturnSolutions solutions: [Solution]) {
		self.solutions = solutions
	}

	func solver(_ solver: MysterySolver, didEncounterError error: MysterySolverError) {
		// TODO: output error
		self.solutions = []
		self.possibleStates = []
		self.optimalInquiries = []
	}

	func solver(_ solver: MysterySolver, didGeneratePossibleStates possibleStates: [PossibleState], for state: GameState) {
		guard state.id == self.gameState.id else { return }
		self.possibleStates = possibleStates
		self.solver.findOptimalInquiry(in: state, withPossibleStates: possibleStates)
	}

}

// MARK: InquiryEvaluatorDelegate

extension EngineState: InquiryEvaluatorDelegate {

	func evaluator(_ evaluator: InquiryEvaluator, didFindOptimalInquiries inquiries: [Inquiry]) {
		self.optimalInquiries = inquiries
	}

	func evaluator(_ evaluator: InquiryEvaluator, didEncounterError error: InquiryEvaluatorError) {
		// TODO: output error
		self.optimalInquiries = []
	}

}

// MARK: - Solver

private protocol SolverDelegate: PossibleStateEliminationSolverDelegate, InquiryEvaluatorDelegate {}

extension EngineState {

	private class Solver: PossibleStateEliminationSolverDelegate, InquiryEvaluatorDelegate {
		private let solverQueue = DispatchQueue(label: "ca.josephroque.FourteenthClue.Solver")
		private let evaluatorQueue = DispatchQueue(label: "ca.josephroque.FourteenthClue.Evaluator")

		private var solver: MysterySolver = PossibleStateEliminationSolver()
		private var evaluator: InquiryEvaluator = BruteForceInquiryEvaluator()

		weak var delegate: SolverDelegate?

		init() {
			solver.delegate = self
			evaluator.delegate = self
		}

		var solverProgress: Double? {
			solver.progress
		}

		var evaluatorProgress: Double? {
			evaluator.progress
		}

		func cancel() {
			self.solver.cancel()
			self.evaluator.cancel()
		}

		func startSolving(state: GameState) {
			solverQueue.async { [weak self] in
				self?.solver.solve(state: state)
			}
		}

		func findOptimalInquiry(in state: GameState, withPossibleStates possibleStates: [PossibleState]) {
			evaluatorQueue.async { [weak self] in
				self?.evaluator.findOptimalInquiry(in: state, withPossibleStates: possibleStates)
			}
		}

		func solver(_ solver: MysterySolver, didReturnSolutions solutions: [Solution]) {
			self.delegate?.solver(self.solver, didReturnSolutions: solutions)
		}

		func solver(_ solver: MysterySolver, didEncounterError error: MysterySolverError) {
			self.delegate?.solver(self.solver, didEncounterError: error)
		}

		func solver(_ solver: MysterySolver, didGeneratePossibleStates possibleStates: [PossibleState], for state: GameState) {
			self.delegate?.solver(self.solver, didGeneratePossibleStates: possibleStates, for: state)
		}

		func evaluator(_ evaluator: InquiryEvaluator, didEncounterError error: InquiryEvaluatorError) {
			self.delegate?.evaluator(self.evaluator, didEncounterError: error)
		}

		func evaluator(_ evaluator: InquiryEvaluator, didFindOptimalInquiries inquiries: [Inquiry]) {
			self.delegate?.evaluator(self.evaluator, didFindOptimalInquiries: inquiries)
		}
	}

}
