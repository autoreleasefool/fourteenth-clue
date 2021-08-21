//
//  InquisitionForm.swift
//  Fourteenth Clue
//
//  Created by Joseph Roque on 2021-07-04.
//

import FourteenthClueKit
import SwiftUI

struct InquisitionForm: View {

	@ObservedObject var viewModel: NewActionViewModel
	let onAddInquisition: (Inquisition) -> Void

	let countFormatter: NumberFormatter = {
		let formatter = NumberFormatter()
		formatter.numberStyle = .decimal
		formatter.allowsFloats = false
		return formatter
	}()

	var body: some View {
		Group {
			Section {
				Picker("Asking Player", selection: $viewModel.viewState.inquisition.askingPlayer) {
					ForEach(viewModel.state.players) { player in
						Text(player.name)
							.tag(player)
					}
				}
			}

			Section {
				Picker("Answering Player", selection: $viewModel.viewState.inquisition.answeringPlayer) {
					ForEach(viewModel.state.players) { player in
						Text(player.name)
							.tag(player)
					}
				}
			}

			Section {
				Picker("Type", selection: $viewModel.viewState.inquisition.type) {
					ForEach(InquisitionType.allCases) { type in
						Text(type.name)
							.tag(type)
					}
				}

				switch viewModel.viewState.inquisition.type {
				case .color:
					Picker("Color", selection: $viewModel.viewState.inquisition.color) {
						ForEach(Card.Color.allCases) { color in
							Text(color.description.capitalized)
								.tag(color)
						}
					}
				case .category:
					Picker("Category", selection: $viewModel.viewState.inquisition.category) {
						ForEach(Card.Category.allCases) { category in
							Text(category.description.capitalized)
								.tag(category)
						}
					}
				}
			}

			Section {
				TextField("Count", value: $viewModel.viewState.inquisition.count, formatter: countFormatter)
					.keyboardType(.numberPad)
			}

			Section {
				Button("Submit") {
					guard let inquisition = viewModel.viewState.inquisition.build(withState: viewModel.state) else { return }
					onAddInquisition(inquisition)
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
