//
//  PossibleStateEliminationSolver.swift
//  Fourteenth Clue
//
//  Created by Joseph Roque on 2021-07-04.
//

import Combine
import Foundation

class PossibleStateEliminationSolver: ClueSolver {

	var state: GameState? = nil {
		didSet {
			if isRunning {
				cancel()
			}

			if let state = state {
				startSolving(state: state)
			}
		}
	}

	var isEnabled: Bool = false {
		didSet {
			if !isEnabled {
				cancel()
			}
		}
	}

	// MARK: Scheduling

	private let queue = DispatchQueue(label: "ca.josephroque.FourteenthClue.StateElimination")

	private var currentWorkItem: DispatchWorkItem?
	private var isRunning: Bool {
		currentWorkItem?.isCancelled == false
	}

	private let solutionsSubject = PassthroughSubject<[Solution], Never>()
	var solutions: AnyPublisher<[Solution], Never> {
		solutionsSubject.eraseToAnyPublisher()
	}

	func cancel() {
		solutionsSubject.send([])
		currentWorkItem?.cancel()
		currentWorkItem = nil
	}

	private func startSolving(state: GameState) {
		guard isEnabled else { return }

		let workItem = DispatchWorkItem { [weak self] in
			self?.solve(state: state)
		}

		currentWorkItem = workItem
		queue.async(execute: workItem)
	}

	// MARK: Solving

	private func solve(state: GameState) {
//		var states = state.allPossibleStates
	}
}

//private extension GameState {
//
//
//
//}
