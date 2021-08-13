//
//  ClueSolver.swift
//  Fourteenth Clue
//
//  Created by Joseph Roque on 2021-06-22.
//

import Combine
import Foundation

class ClueSolver {

	var state: GameState? = nil {
		didSet {
			if let state = state {
				startSolving(state: state, prevState: oldValue)
			} else {
				solutionsSubject.send([])
			}
		}
	}

	var isEnabled: Bool = false {
		didSet {
			if !isEnabled {
				state = nil
			}
		}
	}

	private let queue = DispatchQueue(label: "ca.josephroque.FourteenthClue.ClueSolver")

	let solutionsSubject: PassthroughSubject<[Solution], Never>
	var solutions: AnyPublisher<[Solution], Never> {
		solutionsSubject
			.eraseToAnyPublisher()
	}

	init(solutionsSubject: PassthroughSubject<[Solution], Never>) {
		self.solutionsSubject = solutionsSubject
	}

	private func startSolving(state: GameState, prevState: GameState?) {
		guard isEnabled else { return }
		queue.async { [weak self] in
			guard state.id == self?.state?.id else { return }
			self?.solve(state: state, prevState: prevState)
		}
	}

	open func solve(state: GameState, prevState: GameState?) {
		fatalError("Must be implemented")
	}

}
