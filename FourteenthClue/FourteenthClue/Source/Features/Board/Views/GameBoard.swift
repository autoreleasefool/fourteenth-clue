//
//  GameBoard.swift
//  Fourteenth Clue
//
//  Created by Joseph Roque on 2021-06-22.
//

import BottomSheet
import SwiftUI

struct GameBoard: View {
	@Environment(\.presentationMode) var presentation

	@StateObject var viewModel: GameBoardViewModel

	init(state: GameState) {
		var state = state
		for (index, player) in state.players.enumerated() {
			if player.name.isEmpty {
				state = state.withPlayer(player.withName("Player \(index + 1)"))
			}
		}
		self._viewModel = .init(wrappedValue: GameBoardViewModel(state: state))
	}

	var body: some View {
		VStack(spacing: 0) {
			playerCards
			List {
				clues

				if !viewModel.secretInformants.isEmpty {
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
			CardPicker(cards: viewModel.unallocatedCards.sorted()) {
				viewModel.pickingSecretInformant = nil
				viewModel.setCard($0, forInformant: secretInformant)
			}
		}
		.sheet(isPresented: $viewModel.addingClue) {
			NavigationView {
				ClueForm(state: viewModel.state) { newClue in
					viewModel.addClue(newClue)
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
			ForEach(viewModel.players) { player in
				ScrollView {
					PlayerCardSet(viewModel: viewModel, player: player)
				}
			}
		}
		.tabViewStyle(.page)
		.background(Color.gray)
	}

	private var clues: some View {
		Section("Clues") {
			Button("Add new") {
				viewModel.addClue()
			}
			ForEach(viewModel.clues) { clue in
				Text(clue.description(withPlayers: viewModel.players))
			}
			.onDelete { indexSet in
				viewModel.deleteClues(atOffsets: indexSet)
			}
		}
	}

	private var informants: some View {
		Section("Informants") {
			ForEach(viewModel.secretInformants, id: \.0) { informant in
				Button(label(for: informant.1, withName: informant.0)) {
					viewModel.pickingSecretInformant = informant.1
				}
			}
		}
	}

	private func label(for informant: SecretInformant, withName name: String) -> String {
		if let card = informant.card {
			return "\(name) - \(card)"
		} else {
			return "\(name) - ?"
		}
	}

}
