//
//  GameBuilder.swift
//  Fourteenth Clue
//
//  Created by Joseph Roque on 2021-06-23.
//

import SwiftUI

struct GameBuilder: View {

	@State var state: GameState
	@State var isPlaying = false

	init(playerCount: Int) {
		self._state = .init(initialValue: GameState(playerCount: playerCount))
	}

	var body: some View {
		ZStack {
			NavigationLink("", destination: GameBoard(state: state), isActive: $isPlaying)
			Form {
				Section(header: Text("Players")) {
					ForEach(state.players) { player in
						TextField(getTitle(forPlayer: player), text: getText(forPlayer: player))
					}
				}
			}
		}
		.navigationTitle("Create new game")
		.navigationBarItems(trailing: startButton)
	}

	private var startButton: some View {
		Button("Start") {
			isPlaying = true
		}
	}

	private func getTitle(forPlayer player: GameState.Player) -> String {
		guard let index = state.players.firstIndex(where: { $0.id == player.id }) else { return "" }
		return "Player \(index + 1)"
	}

	private func getText(forPlayer player: GameState.Player) -> Binding<String> {
		Binding<String>(
			get: { player.name },
			set: { state = state.withPlayer(player.withName($0)) }
		)
	}

}
