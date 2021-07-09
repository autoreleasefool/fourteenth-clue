//
//  GameBuilder.swift
//  Fourteenth Clue
//
//  Created by Joseph Roque on 2021-06-23.
//

import SwiftUI

struct GameBuilder: View {

	private let playerCount: Int
	@State var playerNames: [String]
	@State var playerIDs: [String]
	@State var intermediateState: GameState?
	@State var initialState: GameState?

	@State var initialJSONState: String = ""

	init(playerCount: Int) {
		self.playerCount = playerCount
		self._playerNames = .init(initialValue: Array(repeating: "", count: playerCount))
		self._playerIDs = .init(initialValue: (0..<playerCount).map { _ in UUID() }.map { $0.uuidString })
	}

	var body: some View {
		Form {
			ForEach(0..<playerCount) { index in
				Section(header: Text(getTitle(forPlayer: index))) {
					TextField(getTitle(forPlayer: index), text: getText(forPlayer: index))
					TextField("ID", text: getIdText(forPlayer: index))

					if let intermediateState = intermediateState {
						intermediateCards(forPlayer: index, in: intermediateState)
					}
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
		.navigationTitle("Create new game")
		.navigationBarItems(trailing: startButton)
		.navigate(using: $initialState) { initialState in
			GameBoard(state: initialState)
		}
	}

	private func intermediateCards(forPlayer index: Int, in state: GameState) -> some View {
		HStack {
			if index == 0 {
				CardImage(card: state.players[index].privateCards.leftCard)
					.size(.small)
				CardImage(card: state.players[index].privateCards.rightCard)
					.size(.small)
			} else {
				CardImage(card: state.players[index].mystery.person)
					.size(.small)
				CardImage(card: state.players[index].mystery.location)
					.size(.small)
				CardImage(card: state.players[index].mystery.weapon)
					.size(.small)
			}
		}
	}

	private var startButton: some View {
		Button("Start") {
			if initialJSONState.isEmpty {
				initialState = GameState(playerNames: playerNames)
			} else {
				initialState = GameState(playerNames: playerNames, playerIDs: playerIDs, seed: initialJSONState)
			}
		}
	}

	private func getTitle(forPlayer index: Int) -> String {
		"Player \(index + 1)"
	}

	private func getText(forPlayer index: Int) -> Binding<String> {
		Binding<String>(
			get: { playerNames[index] },
			set: { playerNames[index] = $0 }
		)
	}

	private func getIdText(forPlayer index: Int) -> Binding<String> {
		Binding<String>(
			get: { playerIDs[index] },
			set: { playerIDs[index] = $0 }
		)
	}

	private func formatJson() {
		guard let data = initialJSONState.drop(while: { $0 != "{" }).data(using: .utf8),
					let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers),
					let pretty = try? JSONSerialization.data(withJSONObject: json, options: [.sortedKeys, .prettyPrinted]),
					let formatted = String(bytes: pretty, encoding: .utf8),
					let state = GameState(seed: formatted)
		else {
			return
		}
		playerIDs = state.players.map { $0.id }
		initialJSONState = formatted
		intermediateState = state
	}

}
