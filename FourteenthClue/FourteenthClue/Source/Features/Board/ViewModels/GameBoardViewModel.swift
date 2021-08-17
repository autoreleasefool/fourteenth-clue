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
	private var solver: MysterySolver = PossibleStateEliminationSolver()

	private let inquiryQueue = DispatchQueue(label: "ca.josephroque.FourteenthClue.InquiryEvaluator")
	private var inquiryEvaluator: InquiryEvaluator = BruteForceInquiryEvaluator()

	init(state: GameState) {
		self.initialState = state
		self.state = state
	}

	// MARK: View actions

	func onAppear() {
		print("Starting game with \(state.numberOfPlayers) players")
		solver.delegate = self
		inquiryEvaluator.delegate = self
	}

	func onDisappear() {
		solver.cancel()
		inquiryEvaluator.cancel()
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

	func addAction(_ action: AnyAction) {
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
	func solver(_ solver: MysterySolver, didReturnSolutions solutions: [Solution]) {
		DispatchQueue.main.async {
			self.possibleSolutions = solutions
		}
	}

	func solver(_ solver: MysterySolver, didEncounterError error: MysterySolverError) {
		DispatchQueue.main.async {
			self.possibleSolutions = []
		}
	}

	func solver(_ solver: MysterySolver, didGeneratePossibleStates possibleStates: [PossibleState], for state: GameState) {
		inquiryQueue.async { [weak self] in
			self?.inquiryEvaluator.findOptimalInquiry(in: state, withPossibleStates: possibleStates)
		}
	}
}

extension GameBoardViewModel: InquiryEvaluatorDelegate {
	func evaluator(_ evaluator: InquiryEvaluator, didFindOptimalInquiries inquiries: [Inquiry]) {
		print(inquiries)
	}

	func evaluator(_ evaluator: InquiryEvaluator, didEncounterError error: InquiryEvaluatorError) {

	}
}
