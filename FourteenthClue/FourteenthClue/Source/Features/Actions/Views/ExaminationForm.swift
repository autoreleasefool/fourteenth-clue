//
//  ExaminationForm.swift
//  Fourteenth Clue
//
//  Created by Joseph Roque on 2021-08-21.
//

import FourteenthClueKit
import SwiftUI

struct ExaminationForm: View {

	@ObservedObject var viewModel: NewActionViewModel
	let onAddExamination: (Examination) -> Void

	var body: some View {
		Group {
			Section {
				Picker("Examining Player", selection: $viewModel.viewState.examination.examiningPlayer) {
					ForEach(viewModel.state.players) { player in
						Text(player.name)
							.tag(player)
					}
				}
			}

			Section {
				Picker("Informant", selection: $viewModel.viewState.examination.informant) {
					ForEach(viewModel.state.secretInformants) { informant in
						Text(informant.name)
							.tag(informant)
					}
				}
			}

			Section {
				Button("Submit") {
					let examination = viewModel.viewState.examination.build(withState: viewModel.state)
					onAddExamination(examination)
				}
			}
		}
	}

}
