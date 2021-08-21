//
//  NewActionViewModel.swift
//  NewActionViewModel
//
//  Created by Joseph Roque on 2021-08-20.
//

import Combine
import FourteenthClueKit
import SwiftUI

class NewActionViewModel: ObservableObject {

	let state: GameState
	@Published var viewState: NewActionViewState

	init(state: GameState) {
		self.state = state
		self._viewState = .init(initialValue: .init(state: state))
	}

}
