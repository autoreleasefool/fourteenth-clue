//
//  ActionForm.swift
//  Fourteenth Clue
//
//  Created by Joseph Roque on 2021-06-27.
//

import FourteenthClueKit
import SwiftUI

struct ActionForm: View {
	@Environment(\.dismiss) private var dismiss

	@StateObject var viewModel: NewActionViewModel
	let onAddAction: (Action) -> Void

	init(state: GameState, initialAction: NewActionViewState?, onAddAction: @escaping (Action) -> Void) {
		self._viewModel = .init(wrappedValue: .init(state: state, initialViewState: initialAction))
		self.onAddAction = onAddAction
	}

	var body: some View {
		Form {
			CirclePicker(
				pickableItems: viewModel.viewState.enabledTypes,
				selectedItem: $viewModel.viewState.type
			) { actionType in
				Text(actionType.name.prefix(1).capitalized)
			}
			.titled("Action")
			.padding(.vertical)

			switch viewModel.viewState.type {
			case .inquisition:
				InquisitionForm(viewModel: viewModel) { inquisition in
					onAddAction(.inquire(inquisition))
					dismiss()
				}
			case .accusation:
				AccusationForm(viewModel: viewModel) { accusation in
					onAddAction(.accuse(accusation))
					dismiss()
				}
			case .examination:
				ExaminationForm(viewModel: viewModel) { examination in
					onAddAction(.examine(examination))
					dismiss()
				}
			}
		}
		.navigationTitle("Add action")
	}

}

extension ActionForm {

	enum ActionType: String, CaseIterable, Identifiable {
		case inquisition
		case accusation
		case examination

		var id: String {
			rawValue
		}

		var name: String {
			rawValue.capitalized
		}
	}

}

#if DEBUG
struct ActionFormPreview: PreviewProvider {
	static let gameState = GameState(playerCount: 4)

	static var previews: some View {
		ActionForm(
			state: gameState,
			initialAction: .init(state: gameState)
		) { _ in }
	}
}
#endif
