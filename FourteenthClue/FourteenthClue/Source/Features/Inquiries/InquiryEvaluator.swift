//
//  InquiryEvaluator.swift
//  InquiryEvaluator
//
//  Created by Joseph Roque on 2021-08-15.
//

import Combine
import Foundation

class InquiryEvaluator {

	var seed: (baseState: GameState, possibleStates: [PossibleState])? = nil {
		didSet {
			if let seed = seed {
				findOptimalInquiry(baseState: seed.baseState, seed.possibleStates)
			} else {
				inquirySubject.send([])
			}
		}
	}

	var isEnabled: Bool = false {
		didSet {
			if !isEnabled {
				seed = nil
			}
		}
	}

	private let queue = DispatchQueue(label: "ca.josephroque.FourteenthClue.InquiryEvaluator")

	let inquirySubject: PassthroughSubject<[Inquiry], Never>
	var inquiries: AnyPublisher<[Inquiry], Never> {
		inquirySubject
			.eraseToAnyPublisher()
	}

	init(inquirySubject: PassthroughSubject<[Inquiry], Never>) {
		self.inquirySubject = inquirySubject
	}

	private func findOptimalInquiry(baseState: GameState, possibleStates: [PossibleState]) {
		guard isEnabled else {
			inquirySubject.send([])
			return
		}

		queue.async { [weak self] in
			self?.findOptimalInquiry(withBaseState: baseState, toReduce: possibleStates)
		}
	}

	open func findOptimalInquiry(withBaseState baseState: GameState, toReduce possibleStates: [PossibleState]) {
		fatalError("Must be implemented")
	}
}
