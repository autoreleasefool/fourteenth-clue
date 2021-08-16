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
		let reporter = StepReporter(owner: self)

		reporter.reportStep(message: "Beginning inquiry evaluation")

		let inquiries = baseState.allPossibleInquiries()
		reporter.reportStep(message: "Finished generating inquiries")

		var highestExpectedStatesRemoved = 0
		var bestInquiries: [Inquiry] = []

		inquiries.forEach { inquiry in
			guard !baseState.playerHasBeenAsked(inquiry: inquiry) else { return }

			let cardsInCategory = inquiry.category.cards
				.intersection(baseState.cards)

			let totalStatesMatchingInquiry = (1...cardsInCategory.count).map { numberOfCardsSeen in
				possibleStates.filter {
					let cardsInCategoryVisibleToPlayer = $0.cardsVisible(toPlayer: inquiry.player).intersection(cardsInCategory)
					return cardsInCategoryVisibleToPlayer.count == numberOfCardsSeen
				}.count
			}

			let totalStatesRemoved = totalStatesMatchingInquiry.reduce(0, +)

			guard totalStatesRemoved > 0 else { return }

			let statesRemovedByAnswer = totalStatesMatchingInquiry.map { totalStatesRemoved - $0 }
			let probabilityOfAnswer = totalStatesMatchingInquiry.map { Double($0) / Double(totalStatesRemoved) }
			let expectedStatesRemoved = zip(statesRemovedByAnswer, probabilityOfAnswer)
				.map { Double($0) * $1 }
				.reduce(0, +)

			let intExpectedStatesRemoved = Int(expectedStatesRemoved)

			if intExpectedStatesRemoved > highestExpectedStatesRemoved {
				highestExpectedStatesRemoved = intExpectedStatesRemoved
				bestInquiries = [inquiry]
			} else if intExpectedStatesRemoved == highestExpectedStatesRemoved {
				bestInquiries.append(inquiry)
			}
		}

		reporter.reportStep(message: "Finished evaluating \(bestInquiries.count) inquiries, with expected value of \(highestExpectedStatesRemoved)")

		subject.send(bestInquiries)
	}
}
