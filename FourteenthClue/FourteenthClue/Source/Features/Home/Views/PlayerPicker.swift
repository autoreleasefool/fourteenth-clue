//
//  PlayerPicker.swift
//  Fourteenth Clue
//
//  Created by Joseph Roque on 2021-06-22.
//

import SwiftUI

struct PlayerPicker: View {

	var body: some View {
		List {
			ForEach(2..<7) { playerCount in
				NavigationLink("\(playerCount) players", destination: GameBuilder(playerCount: playerCount))
			}
		}
		.navigationTitle("New game")
	}

}
