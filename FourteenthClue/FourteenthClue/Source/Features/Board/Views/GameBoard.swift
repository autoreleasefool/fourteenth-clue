//
//  GameBoard.swift
//  Fourteenth Clue
//
//  Created by Joseph Roque on 2021-06-22.
//

import SwiftUI

struct GameBoard: View {

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
			TabView {
				ForEach(viewModel.players) { player in
					ScrollView {
						PlayerCardSet(viewModel: viewModel, player: player)
					}
				}
			}
			.tabViewStyle(.page)
			.background(Color.gray)
			List {
				Section("Clues") {
					Button("Add new") {
						viewModel.addingClue = true
					}
					ForEach(viewModel.clues) { clue in
						Text(clue.description(withPlayer: viewModel.player(withId: clue.player)))
					}
					.onDelete { indexSet in
						viewModel.deleteClues(atOffsets: indexSet)
					}
				}

				Section("Informants") {
					ForEach(viewModel.secretInformants) { informant in
						Button(informant.description) {
							viewModel.pickingSecretInformant = informant
						}
					}
				}
			}
		}
		.navigationTitle("13 Clues")
		.navigationBarBackButtonHidden(true)
		.onAppear {
			viewModel.onAppear()
		}
		.sheet(item: $viewModel.pickingSecretInformant) { secretInformant in
			CardPicker(cards: viewModel.availableCards.sorted()) {
				viewModel.pickingSecretInformant = nil
				viewModel.setCard($0, forInformant: secretInformant.informant)
			}
		}
		.sheet(isPresented: $viewModel.addingClue) {
			ClueForm(state: viewModel.state) { newClue in
				viewModel.addClue(newClue)
			}
		}
	}

}
