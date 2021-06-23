//
//  GameBuilder.swift
//  Fourteenth Clue
//
//  Created by Joseph Roque on 2021-06-23.
//

import SwiftUI

struct GameBuilder: View {

	@State private var state: GameState
	@State private var isPlaying = false

	init(playerCount: Int) {
		self._state = .init(initialValue: GameState(playerCount: playerCount))
	}

	var body: some View {
		ZStack {
			NavigationLink("", destination: GameBoard(state: state), isActive: $isPlaying)
			Form {
				Section(header: Text("Players")) {
					ForEach(0..<state.players.count) { index in
						TextField("Player \(index + 1)", text: getText(forIndex: index))
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

	private func getText(forIndex index: Int) -> Binding<String> {
		Binding<String>(
			get: { state.players[index].name },
			set: { state.players[index].name = $0 }
		)
	}

}
