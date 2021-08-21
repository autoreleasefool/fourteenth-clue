//
//  FourteenthClue.swift
//  Fourteenth Clue
//
//  Created by Joseph Roque on 2021-06-21.
//

import FourteenthClueKit
import SwiftUI

@main
struct FourteenthClue: App {

	init() {
		FourteenthClueKit.Configuration.isLoggingEnabled = true
	}

	var body: some Scene {
		WindowGroup {
			Home()
		}
	}

}
