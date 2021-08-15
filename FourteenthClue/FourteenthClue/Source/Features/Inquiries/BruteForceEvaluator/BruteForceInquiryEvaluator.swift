//
//  BruteForceInquiryEvaluator.swift
//  BruteForceInquiryEvaluator
//
//  Created by Joseph Roque on 2021-08-15.
//

import Combine
import Foundation

class BruteForceInquiryEvaluator: InquiryEvaluator {

	private let subject: PassthroughSubject<[Inquiry], Never>

	init() {
		let subject = PassthroughSubject<[Inquiry], Never>()
		self.subject = subject
		super.init(inquirySubject: subject)
	}

	override func findOptimalInquiry(withBaseState baseState: GameState, toReduce possibleStates: [PossibleState]) {
		
	}
}
