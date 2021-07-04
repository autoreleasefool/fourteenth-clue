//
//  ClueForm.swift
//  Fourteenth Clue
//
//  Created by Joseph Roque on 2021-06-27.
//

import SwiftUI

struct ClueForm: View {
	@Environment(\.dismiss) private var dismiss

	let state: GameState
	let onAddClue: (Clue) -> Void

	@State private var selectedPlayer: Player
	@State private var clueType: ClueType = .color
	@State private var clueColor: Card.Color = Card.Color.allCases.first!
	@State private var clueCategory: Card.Category = Card.Category.allCases.first!
	@State private var count: Int?

	let countFormatter: NumberFormatter = {
		let formatter = NumberFormatter()
		formatter.numberStyle = .decimal
		formatter.allowsFloats = false
		return formatter
	}()

	init(state: GameState, onAddClue: @escaping (Clue) -> Void) {
		self.state = state
		self.onAddClue = onAddClue
		self._selectedPlayer = .init(wrappedValue: state.players.first!)
	}

	var body: some View {
		Form {
			Section {
				Picker("Player", selection: $selectedPlayer) {
					ForEach(state.players) { player in
						Text(player.name)
							.tag(player)
					}
				}
			}

			Section {
				Picker("Type", selection: $clueType) {
					ForEach(ClueType.allCases) { type in
						Text(type.rawValue.capitalized)
							.tag(type)
					}
				}

				switch clueType {
				case .color:
					Picker("Color", selection: $clueColor) {
						ForEach(Card.Color.allCases) { color in
							Text(color.description.capitalized)
								.tag(color)
						}
					}
				case .category:
					Picker("Category", selection: $clueCategory) {
						ForEach(Card.Category.allCases) { category in
							Text(category.description.capitalized)
								.tag(category)
						}
					}
				}
			}

			Section {
				TextField("Count", value: $count, formatter: countFormatter)
					.keyboardType(.numberPad)
			}

			Section {
				Button("Submit") {
					guard let count = count else { return }

					let filter: Clue.Filter
					switch clueType {
					case .color:
						filter = .color(clueColor)
					case .category:
						filter = .category(clueCategory)
					}

					onAddClue(Clue(
						player: selectedPlayer.id,
						filter: filter,
						count: count
					))

					dismiss()
				}
			}
		}
		.navigationTitle("Add clue")
	}

}

extension ClueForm {

	enum ClueType: String, CaseIterable, Identifiable {
		case color
		case category

		var id: String {
			rawValue
		}

	}

}
