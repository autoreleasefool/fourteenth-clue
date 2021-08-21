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
	let onAddAction: (AnyAction) -> Void

	init(state: GameState, onAddAction: @escaping (AnyAction) -> Void) {
		self._viewModel = .init(wrappedValue: .init(state: state))
		self.onAddAction = onAddAction
	}

	var body: some View	{
		Form {
			Picker("Action", selection: $viewModel.viewState.type) {
				ForEach(NewActionViewState.ActionType.allCases) { actionType in
					Text(actionType.name)
						.tag(actionType)
				}
			}

			switch viewModel.viewState.type {
			case .inquisition:
				InquisitionForm(viewModel: viewModel) { inquisition in
					onAddAction(AnyAction(inquisition))
					dismiss()
				}
			case .accusation:
				AccusationForm(viewModel: viewModel) { accusation in
					onAddAction(AnyAction(accusation))
					dismiss()
				}
			case .examination:
//				ExaminationForm(state: state) { examination in
//					onAddAction(AnyAction(examination))
//					dismiss()
//				}
				EmptyView()
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
