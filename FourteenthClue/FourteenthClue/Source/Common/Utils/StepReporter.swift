//
//  StepReporter.swift
//  StepReporter
//
//  Created by Joseph Roque on 2021-08-11.
//

import Foundation

class StepReporter {
	let ownerName: String
	let startTime: DispatchTime
	var steps = 0

	init(owner: Any) {
		self.ownerName = String(describing: owner)
		startTime = DispatchTime.now()
	}

	func reportStep(message: String) {
		steps += 1

		let currentTime = DispatchTime.now()
		let nanoTime = currentTime.uptimeNanoseconds - startTime.uptimeNanoseconds
		let timeInterval = Double(nanoTime) / 1_000_000_000

		print("[\(ownerName)][\(String(format: "%.2f", timeInterval))] \(steps). \(message)")
	}
}
