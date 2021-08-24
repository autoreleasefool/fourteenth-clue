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
	private(set) var finishedEvaluatingInquiries: Bool = false

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
		solver.cancel(state: gameState)
	}

	var solverProgress: Double? {
		solver.progressSolving(state: gameState)
	}

	var evaluatorProgress: Double? {
		solver.progressEvaluating(state: gameState)
	}

}

// MARK: PossibleStateEliminationSolverDelegate

extension EngineState: PossibleStateEliminationSolverDelegate {

	func solver(_ solver: MysterySolver, didReturnSolutions solutions: [Solution], forState state: GameState) {
		self.solutions = solutions
	}

	func solver(_ solver: MysterySolver, didEncounterError error: MysterySolverError, forState state: GameState) {
		self.solutions = []
		self.possibleStates = []
		self.optimalInquiries = []
	}

	func solver(
		_ solver: MysterySolver,
		didGeneratePossibleStates possibleStates: [PossibleState],
		forState state: GameState
	) {
		guard state.id == self.gameState.id else { return }
		self.possibleStates = possibleStates
		self.finishedEvaluatingInquiries = false
		self.solver.findOptimalInquiry(in: state, withPossibleStates: possibleStates)
	}

}

// MARK: InquiryEvaluatorDelegate

extension EngineState: InquiryEvaluatorDelegate {

	func evaluator(
		_ evaluator: InquiryEvaluator,
		didFindOptimalInquiries inquiries: [Inquiry],
		forState state: GameState
	) {
		self.optimalInquiries = inquiries
	}

	func evaluator(
		_ evaluator: InquiryEvaluator,
		didEncounterError error: InquiryEvaluatorError,
		forState state: GameState
	) {
		switch error {
		case .completed:
			self.finishedEvaluatingInquiries = true
		case .cancelled:
			self.optimalInquiries = []
		}
	}

}

// MARK: - Solver

private protocol SolverDelegate: PossibleStateEliminationSolverDelegate, InquiryEvaluatorDelegate {}

extension EngineState {

	private class Solver: PossibleStateEliminationSolverDelegate, InquiryEvaluatorDelegate {
		private let solverQueue = DispatchQueue(label: "ca.josephroque.FourteenthClue.Solver")
		private let evaluatorQueue = DispatchQueue(label: "ca.josephroque.FourteenthClue.Evaluator")

		private var solver: MysterySolver = PossibleStateEliminationSolver()
		private var evaluator: InquiryEvaluator = SamplingInquiryEvaluator(
			baseEvaluator: BruteForceInquiryEvaluator(
				evaluator: ExpectedStates.RemovedByInquiryEvaluator.self,
				maxConcurrentTasks: ProcessInfo.processInfo.activeProcessorCount
			),
			sampleRate: 0.1
		)

		weak var delegate: SolverDelegate?

		init() {
			solver.delegate = self
			evaluator.delegate = self
			evaluator.isStreamingInquiries = true
		}

		func progressSolving(state: GameState) -> Double? {
			solver.progressSolving(state: state)
		}

		func progressEvaluating(state: GameState) -> Double? {
			evaluator.progressEvaluating(state: state)
		}

		func cancel(state: GameState) {
			self.solver.cancelSolving(state: state)
			self.evaluator.cancelEvaluating(state: state)
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

		func solver(_ solver: MysterySolver, didReturnSolutions solutions: [Solution], forState state: GameState) {
			self.delegate?.solver(self.solver, didReturnSolutions: solutions, forState: state)
		}

		func solver(_ solver: MysterySolver, didEncounterError error: MysterySolverError, forState state: GameState) {
			self.delegate?.solver(self.solver, didEncounterError: error, forState: state)
		}

		func solver(
			_ solver: MysterySolver,
			didGeneratePossibleStates possibleStates: [PossibleState],
			forState state: GameState
		) {
			self.delegate?.solver(self.solver, didGeneratePossibleStates: possibleStates, forState: state)
		}

		func evaluator(
			_ evaluator: InquiryEvaluator,
			didEncounterError error: InquiryEvaluatorError,
			forState state: GameState
		) {
			self.delegate?.evaluator(self.evaluator, didEncounterError: error, forState: state)
		}

		func evaluator(
			_ evaluator: InquiryEvaluator,
			didFindOptimalInquiries inquiries: [Inquiry],
			forState state: GameState
		) {
			self.delegate?.evaluator(self.evaluator, didFindOptimalInquiries: inquiries, forState: state)
		}
	}

}
