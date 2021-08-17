//
//  InquisitionForm.swift
//  Fourteenth Clue
//
//  Created by Joseph Roque on 2021-07-04.
//

import FourteenthClueKit
import SwiftUI

struct InquisitionForm: View {

	private let state: GameState
	private let onAddClue: (AnyClue) -> Void

	@State private var selectedAskingPlayer: Player
	@State private var selectedAnsweringPlayer: Player
	@State private var inquisitionType: InquisitionType = .color
	@State private var inquisitionColor: Card.Color = Card.Color.allCases.first!
	@State private var inquisitionCategory: Card.Category = Card.Category.allCases.first!
	@State private var count: Int?

	let countFormatter: NumberFormatter = {
		let formatter = NumberFormatter()
		formatter.numberStyle = .decimal
		formatter.allowsFloats = false
		return formatter
	}()

	init(state: GameState, onAddClue: @escaping (AnyClue) -> Void) {
		self.state = state
		self.onAddClue = onAddClue
		self._selectedAskingPlayer = .init(initialValue: state.players.first!)
		self._selectedAnsweringPlayer = .init(initialValue: state.players.first!)
	}

	var body: some View {
		Group {
			Section {
				Picker("Asking Player", selection: $selectedAskingPlayer) {
					ForEach(state.players) { player in
						Text(player.name)
							.tag(player)
					}
				}
			}

			Section {
				Picker("Answering Player", selection: $selectedAnsweringPlayer) {
					ForEach(state.players) { player in
						Text(player.name)
							.tag(player)
					}
				}
			}

			Section {
				Picker("Type", selection: $inquisitionType) {
					ForEach(InquisitionType.allCases) { type in
						Text(type.name)
							.tag(type)
					}
				}

				switch inquisitionType {
				case .color:
					Picker("Color", selection: $inquisitionColor) {
						ForEach(Card.Color.allCases) { color in
							Text(color.description.capitalized)
								.tag(color)
						}
					}
				case .category:
					Picker("Category", selection: $inquisitionCategory) {
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

					let filter: Card.Filter
					switch inquisitionType {
					case .color:
						filter = .color(inquisitionColor)
					case .category:
						filter = .category(inquisitionCategory)
					}

					onAddClue(AnyClue(Inquisition(
						ordinal: state.actions.count,
						askingPlayer: selectedAskingPlayer.id,
						answeringPlayer: selectedAnsweringPlayer.id,
						filter: filter,
						count: count
					)))
				}
			}
		}
	}
}

extension InquisitionForm {

	enum InquisitionType: String, CaseIterable, Identifiable {
		case color
		case category

		var id: String {
			rawValue
		}

		var name: String {
			rawValue.capitalized
		}
	}

}
