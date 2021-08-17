//
//  ClueForm.swift
//  Fourteenth Clue
//
//  Created by Joseph Roque on 2021-06-27.
//

import FourteenthClueKit
import SwiftUI

struct ClueForm: View {
	@Environment(\.dismiss) private var dismiss

	let state: GameState
	let onAddClue: (AnyClue) -> Void

	@State private var clueType: ClueType = .inquisition

	var body: some View	{
		Form {
			Picker("Type of clue", selection: $clueType) {
				ForEach(ClueType.allCases) { clueType in
					Text(clueType.name)
						.tag(clueType)
				}
			}

			switch clueType {
			case .inquisition:
				InquisitionForm(state: state) { clue in
					onAddClue(clue)
					dismiss()
				}
			case .accusation:
				AccusationForm(state: state) { clue in
					onAddClue(clue)
					dismiss()
				}
			}
		}
		.navigationTitle("Add clue")
	}

}

extension ClueForm {

	enum ClueType: String, CaseIterable, Identifiable {
		case inquisition
		case accusation

		var id: String {
			rawValue
		}

		var name: String {
			rawValue.capitalized
		}
	}

}
