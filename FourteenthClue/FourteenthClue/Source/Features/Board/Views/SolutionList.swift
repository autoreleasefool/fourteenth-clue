//
//  SolutionList.swift
//  Fourteenth Clue
//
//  Created by Joseph Roque on 2021-06-28.
//

import SwiftUI

struct SolutionList: View {

	let solutions: [Solution]

	var body: some View {
		List {
			ForEach(solutions) { solution in
				HStack {
					Text(readableProbability(solution.probability))

					CardImage(card: solution.person)
						.size(.medium)

					CardImage(card: solution.location)
						.size(.medium)

					CardImage(card: solution.weapon)
						.size(.medium)
				}
			}
		}
		.navigationTitle("Solutions")
	}

	private func readableProbability(_ probability: Double) -> String {
		String(format: "%.2f", probability * 100)
	}

}
