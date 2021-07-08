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
					Text("\(solution.probability)")

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

}
