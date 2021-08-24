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

	init(state: GameState, onAddAction: @escaping (Action) -> Void) {
		self._viewModel = .init(wrappedValue: .init(state: state))
		self.onAddAction = onAddAction
	}

	var body: some View {
		Form {
			Picker("Action", selection: $viewModel.viewState.type) {
				ForEach(viewModel.viewState.enabledTypes) { actionType in
					Text(actionType.name)
						.tag(actionType)
				}
			}

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
