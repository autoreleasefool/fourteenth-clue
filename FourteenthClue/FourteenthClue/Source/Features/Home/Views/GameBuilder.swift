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

	@State var initialJSONState: String = ""

	init(playerCount: Int) {
		self._state = .init(initialValue: GameState(playerCount: playerCount))
	}

	var body: some View {
		ZStack {
			NavigationLink("", destination: GameBoard(state: state), isActive: $isPlaying)

			Form {
				ForEach(state.players) { player in
					Section(header: Text(getTitle(forPlayer: player))) {
						TextField(getTitle(forPlayer: player), text: getText(forPlayer: player))
						TextField("ID", text: getIdText(forPlayer: player))
					}
				}

				Section(header: Text("Initial state")) {
					TextEditor(text: $initialJSONState)
						.font(.caption)
						.onChange(of: initialJSONState) { _ in
							formatJson()
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

	private func getTitle(forPlayer player: Player) -> String {
		guard let index = state.players.firstIndex(where: { $0.id == player.id }) else { return "" }
		return "Player \(index + 1)"
	}

	private func getText(forPlayer player: Player) -> Binding<String> {
		Binding<String>(
			get: { player.name },
			set: { state = state.withPlayer(player.withName($0)) }
		)
	}

	private func getIdText(forPlayer player: Player) -> Binding<String> {
		Binding<String>(
			get: { player.id },
			set: { state = state.withPlayer(player.withId($0)) }
		)
	}

	private func formatJson() {
		guard let data = initialJSONState.drop(while: { $0 != "{" }).data(using: .utf8),
					let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers),
					let pretty = try? JSONSerialization.data(withJSONObject: json, options: [.sortedKeys, .prettyPrinted]),
					let formatted = String(bytes: pretty, encoding: .utf8) else {
						return
					}
		initialJSONState = formatted
	}

}
