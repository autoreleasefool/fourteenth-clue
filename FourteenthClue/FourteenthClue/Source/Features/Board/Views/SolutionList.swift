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
					Image(uiImage: solution.person.image)
						.resizable()
						.frame(width: 60, height: 100)
					Image(uiImage: solution.location.image)
						.resizable()
						.frame(width: 60, height: 100)
					Image(uiImage: solution.weapon.image)
						.resizable()
						.frame(width: 60, height: 100)
				}
			}
		}
		.navigationTitle("Solutions")
	}

}
