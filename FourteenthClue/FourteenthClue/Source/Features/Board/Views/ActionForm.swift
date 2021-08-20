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

	let state: GameState
	let onAddAction: (AnyAction) -> Void

	@State private var actionType: ActionType = .inquisition

	var body: some View	{
		Form {
			Picker("Action", selection: $actionType) {
				ForEach(ActionType.allCases) { actionType in
					Text(actionType.name)
						.tag(actionType)
				}
			}

			switch actionType {
			case .inquisition:
				InquisitionForm(state: state) { inquisition in
					onAddAction(AnyAction(inquisition))
					dismiss()
				}
			case .accusation:
				AccusationForm(state: state) { accusation in
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
