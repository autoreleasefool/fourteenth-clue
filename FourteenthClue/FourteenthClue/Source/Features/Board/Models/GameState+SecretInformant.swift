//
//  GameState+SecretInformant.swift
//  Fourteenth Clue
//
//  Created by Joseph Roque on 2021-06-27.
//

import Foundation

extension GameState {

	struct SecretInformant {

		let id: UUID
		let card: Card?

		static var `default`: SecretInformant {
			.init(card: nil)
		}

		init(id: UUID = UUID(), card: Card?) {
			self.id = id
			self.card = card
		}

		// MARK: Mutations

		func withCard(_ card: Card?) -> SecretInformant {
			.init(id: id, card: card)
		}
	}
}
