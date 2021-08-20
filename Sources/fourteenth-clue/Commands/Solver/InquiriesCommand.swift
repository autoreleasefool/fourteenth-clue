//
//  InquiriesCommand.swift
//  FourteenthClue
//
//  Created by Joseph Roque on 2021-08-19.
//

struct InquiriesCommand: RunnableCommand {

	static var help: String {
		"""
		inquiries [i]: show best inquiry to make.
		"""
	}

	init?(_ string: String) {
		guard string == "inquiries" || string == "i" else { return nil }
	}

	func run(_ state: EngineState) throws {
		guard !state.optimalInquiries.isEmpty else {
			print("Still calculating optimal inquiry...")
			return
		}

		state.optimalInquiries.enumerated()
			.forEach { index, inquiry in
				print("\(index + 1). Ask \(inquiry.player) about \(inquiry.filter)")
			}
	}

}
