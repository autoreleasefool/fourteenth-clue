//
//  InquiriesCommand.swift
//  FourteenthClue
//
//  Created by Joseph Roque on 2021-08-19.
//

import ConsoleKit

struct InquiriesCommand: RunnableCommand {

	static var name: String {
		"inquiries"
	}

	static var shortName: String? {
		"i"
	}

	static var help: [ConsoleTextFragment] {
		[.init(string: "show best inquiry to make.")]
	}

	init?(_ string: String) {
		guard string == "inquiries" || string == "i" else { return nil }
	}

	func run(_ state: EngineState) throws {
		guard !state.optimalInquiries.isEmpty else {
			state.context.console.warning("Still calculating optimal inquiry...")
			return
		}

		state.optimalInquiries.enumerated()
			.forEach { index, inquiry in
				state.context.console.output(.init(fragments:
					"\(index + 1). Ask \(inquiry.player) about \(inquiry.filter)"
						.consoleText(withState: state.gameState)
					)
				)
			}
	}

}
