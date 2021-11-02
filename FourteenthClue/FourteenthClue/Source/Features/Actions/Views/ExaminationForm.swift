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
				CirclePicker(
					pickableItems: viewModel.state.players,
					selectedItem: $viewModel.viewState.examination.examiningPlayer
				) { player in
					Text(player.name.prefix(2).capitalized)
				}
				.titled("Examining Player")
				.padding(.vertical)
			}

			Section {
				CirclePicker(
					pickableItems: viewModel.state.secretInformants,
					selectedItem: $viewModel.viewState.examination.informant
				) { informant in
					Text(informant.name.prefix(2).capitalized)
				}
				.titled("Informant")
				.padding(.vertical)
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

#if DEBUG
struct ExaminationFormPreview: PreviewProvider {
	static let gameState = GameState(playerCount: 4)

	static var previews: some View {
		Form {
			ExaminationForm(
				viewModel: .init(
					state: gameState,
					initialViewState: .init(state: gameState)
				)
			) { _ in }
		}
	}
}
#endif
