//
//  GameBoard.swift
//  Fourteenth Clue
//
//  Created by Joseph Roque on 2021-06-22.
//

import BottomSheet
import FourteenthClueKit
import SwiftUI

struct GameBoard: View {
	@Environment(\.presentationMode) var presentation

	@StateObject var viewModel: GameBoardViewModel

	init(state: GameState) {
		var state = state
		for (index, player) in state.players.enumerated() {
			if player.name.isEmpty {
				state = state.with(player: player.with(name: "Player \(index + 1)"), atIndex: index)
			}
		}
		self._viewModel = .init(wrappedValue: GameBoardViewModel(state: state))
	}

	var body: some View {
		VStack(spacing: 0) {
			playerCards
			List {
				actions

				if !viewModel.state.secretInformants.isEmpty {
					informants
				}
			}
		}
		.navigationBarTitle("13 Clues", displayMode: .inline)
		.navigationBarBackButtonHidden(true)
		.navigationBarItems(leading: resetButton, trailing: solutionsButton)
		.onAppear { viewModel.onAppear() }
		.onDisappear { viewModel.onDisappear() }
		.sheet(isPresented: $viewModel.showingSolutions) {
			NavigationView {
				SolutionList(solutions: viewModel.possibleSolutions)
			}
		}
		.sheet(item: $viewModel.pickingSecretInformant) { secretInformant in
			CardPicker(cards: viewModel.state.unallocatedCards.sorted()) {
				viewModel.pickingSecretInformant = nil
				viewModel.setCard($0, forInformant: secretInformant)
			}
		}
		.sheet(isPresented: $viewModel.recordingAction) {
			NavigationView {
				ClueForm(state: viewModel.state) { newClue in
					viewModel.addAction(AnyAction(newClue.wrappedValue))
				}
			}
		}
		.alert("Reset game?", isPresented: $viewModel.resettingState) {
			Button("Reset", role: .destructive) {
				viewModel.resetState()
			}

			Button("Cancel", role: .cancel) {
				viewModel.cancelReset()
			}
		}
	}

	private var solutionsButton: some View {
		Button("Solutions") {
			viewModel.showSolutions()
		}
		.disabled(viewModel.possibleSolutions.isEmpty)
	}

	private var resetButton: some View {
		Button("Reset") {
			viewModel.promptResetState()
		}
	}

	private var playerCards: some View {
		TabView {
			ForEach(viewModel.state.players) { player in
				ScrollView {
					PlayerCardSet(viewModel: viewModel, player: player)
				}
			}
		}
		.tabViewStyle(.page)
		.background(Color.gray)
	}

	private var actions: some View {
		Section("Actions") {
			Button("Add new") {
				viewModel.recordAction()
			}
			ForEach(viewModel.state.actions) { action in
				Text(action.description(withState: viewModel.state))
			}
			.onDelete { indexSet in
				viewModel.deleteActions(atOffsets: indexSet)
			}
		}
	}

	private var informants: some View {
		Section("Informants") {
			ForEach(viewModel.state.secretInformants) { informant in
				Button(label(for: informant)) {
					viewModel.pickingSecretInformant = informant
				}
			}
		}
	}

	private func label(for informant: SecretInformant) -> String {
		if let card = informant.card {
			return "\(informant.name) - \(card)"
		} else {
			return "\(informant.name) - ?"
		}
	}

}
