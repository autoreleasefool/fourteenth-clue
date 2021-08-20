//
//  EngineState.swift
//  FourteenthClue
//
//  Created by Joseph Roque on 2021-08-18.
//

import Foundation
import FourteenthClueKit

class EngineState: SolverDelegate {

	private(set) var gameState: GameState
	private(set) var hasShownHelp: Bool
	private(set) var isRunning: Bool

	private(set) var possibleStates: [PossibleState]
	private(set) var solutions: [Solution]
	private(set) var optimalInquiries: [Inquiry]

	private var solver = Solver()

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
		self.optimalInquiries = []

		self.solver.delegate = self
	}

	func updateState(to gameState: GameState) {
		self.gameState = gameState
		self.possibleStates = []

		guard gameState.isSolveable else { return }
		solver.startSolving(state: gameState)
	}

	func didShowHelp() {
		hasShownHelp = true

		DispatchQueue.main.async {
			print("what the fuckl")
		}
	}

	func stop() {
		isRunning = false
		solver.cancel()
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
			DispatchQueue.main.async {
				print("what the fuck")
				self.delegate?.solver(self.solver, didReturnSolutions: solutions)
			}
		}

		func solver(_ solver: MysterySolver, didEncounterError error: MysterySolverError) {
			DispatchQueue.main.async {
				self.delegate?.solver(self.solver, didEncounterError: error)
			}
		}

		func solver(_ solver: MysterySolver, didGeneratePossibleStates possibleStates: [PossibleState], for state: GameState) {
			DispatchQueue.main.async {
				self.delegate?.solver(self.solver, didGeneratePossibleStates: possibleStates, for: state)
			}
		}

		func evaluator(_ evaluator: InquiryEvaluator, didEncounterError error: InquiryEvaluatorError) {
			DispatchQueue.main.async {
				self.delegate?.evaluator(self.evaluator, didEncounterError: error)
			}
		}

		func evaluator(_ evaluator: InquiryEvaluator, didFindOptimalInquiries inquiries: [Inquiry]) {
			DispatchQueue.main.async {
				self.delegate?.evaluator(self.evaluator, didFindOptimalInquiries: inquiries)
			}
		}
	}

}
