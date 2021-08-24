//
//  GameBoardViewModel.swift
//  Fourteenth Clue
//
//  Created by Joseph Roque on 2021-06-22.
//

import Combine
import Foundation
import FourteenthClueKit

class GameBoardViewModel: ObservableObject {

	@Published var state: GameState {
		didSet {
			startSolving(state: state)
		}
	}
	@Published var pickingSecretInformant: SecretInformant?
	@Published var recordingAction = false
	@Published var showingSolutions = false
	@Published var resettingState = false
	@Published var possibleSolutions: [Solution] = []

	private let initialState: GameState

	private let solverQueue = DispatchQueue(label: "ca.josephroque.FourteenthClue.MysterySolver")
	private var solver: MysterySolver =
		PossibleStateEliminationSolver(maxConcurrentTasks: ProcessInfo.processInfo.activeProcessorCount)

	private let actionsQueue = DispatchQueue(label: "ca.josephroque.FourteenthClue.ActionEvaluator")
	private var actionsEvaluator: PotentialActionEvaluator = BruteForceActionEvaluator(
		evaluator: ExpectedStates.RemovedByActionEvaluator.self,
		maxConcurrentTasks: ProcessInfo.processInfo.activeProcessorCount
	)


	init(state: GameState) {
		self.initialState = state
		self.state = state
		self.actionsEvaluator.isStreamingActions = true
	}

	// MARK: View actions

	func onAppear() {
		print("Starting game with \(state.numberOfPlayers) players")
		solver.delegate = self
		actionsEvaluator.delegate = self
	}

	func onDisappear() {
		solver.cancelSolving(state: state)
		actionsEvaluator.cancelEvaluating(state: state)
	}

	func promptResetState() {
		self.resettingState = true
	}

	func resetState() {
		self.resettingState = false
		self.state = initialState
	}

	func cancelReset() {
		self.resettingState = false
	}

	func recordAction() {
		recordingAction = true
	}

	func showSolutions() {
		showingSolutions = true
	}

	func setCard(_ card: Card?, forPlayer player: Player, atPosition position: Card.Position) {
		guard let index = state.players.firstIndex(of: player) else { return }
		switch position {
		case .hiddenLeft:
			state = state.with(player: player.withHiddenCard(onLeft: card), atIndex: index)
		case .hiddenRight:
			state = state.with(player: player.withHiddenCard(onRight: card), atIndex: index)
		case .person:
			state = state.with(player: player.withMysteryPerson(card), atIndex: index)
		case .location:
			state = state.with(player: player.withMysteryLocation(card), atIndex: index)
		case .weapon:
			state = state.with(player: player.withMysteryWeapon(card), atIndex: index)
		}
	}

	func setCard(_ card: Card?, forInformant informant: SecretInformant) {
		state = state.with(secretInformant: informant.with(card: card))
	}

	func addAction(_ action: Action) {
		state = state.appending(action: action)
	}

	func deleteActions(atOffsets offsets: IndexSet) {
		state = state.removingActions(atOffsets: offsets)
	}

	func player(withId id: String) -> Player? {
		state.players.first { $0.id == id }
	}

	private func startSolving(state: GameState) {
		solverQueue.async { [weak self] in
			guard let self = self else { return }
			self.solver.solve(state: state)
		}
	}

}

extension GameBoardViewModel: PossibleStateEliminationSolverDelegate {
	func solver(_ solver: MysterySolver, didReturnSolutions solutions: [Solution], forState state: GameState) {
		DispatchQueue.main.async {
			self.possibleSolutions = solutions
		}
	}

	func solver(_ solver: MysterySolver, didEncounterError error: MysterySolverError, forState state: GameState) {
		DispatchQueue.main.async {
			self.possibleSolutions = []
		}
	}

	func solver(_ solver: MysterySolver, didGeneratePossibleStates possibleStates: [PossibleState], forState state: GameState) {
		actionsQueue.async { [weak self] in
			self?.actionsEvaluator.findOptimalAction(in: state, withPossibleStates: possibleStates)
		}
	}
}

extension GameBoardViewModel: PotentialActionEvaluatorDelegate {
	func evaluator(_ evaluator: PotentialActionEvaluator, didFindOptimalActions actions: [PotentialAction], forState: GameState) {
		print("Updated best actions: \(actions)")
	}

	func evaluator(_ evaluator: PotentialActionEvaluator, didEncounterError error: PotentialActionEvaluatorError, forState: GameState) {

	}
}
