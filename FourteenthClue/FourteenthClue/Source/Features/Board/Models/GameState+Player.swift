//
//  GameState+Player.swift
//  Fourteenth Clue
//
//  Created by Joseph Roque on 2021-06-27.
//

import Foundation

extension GameState {

	struct Player: Identifiable, Hashable {

		let id: UUID
		let name: String
		let privateCards: PrivateCardSet
		let mystery: MysteryCardSet

		static var `default`: Player {
			.init(name: "", privateCards: PrivateCardSet(), mystery: MysteryCardSet())
		}

		init(id: UUID = UUID(), name: String, privateCards: PrivateCardSet, mystery: MysteryCardSet) {
			self.id = id
			self.name = name
			self.privateCards = privateCards
			self.mystery = mystery
		}

		// MARK: Mutations

		func withName(_ newName: String) -> Player {
			.init(id: id, name: newName, privateCards: privateCards, mystery: mystery)
		}

		func withPrivateCard(onLeft: Card? = nil) -> Player {
				.init(id: id, name: name, privateCards: privateCards.withCard(onLeft: onLeft), mystery: mystery)
		}

		func withPrivateCard(onRight: Card? = nil) -> Player {
			.init(id: id, name: name, privateCards: privateCards.withCard(onRight: onRight), mystery: mystery)
		}

		func withMysteryPerson(_ toCard: Card? = nil) -> Player {
			.init(id: id, name: name, privateCards: privateCards, mystery: mystery.withPerson(toCard))
		}

		func withMysteryLocation(_ toCard: Card? = nil) -> Player {
			.init(id: id, name: name, privateCards: privateCards, mystery: mystery.withLocation(toCard))
		}

		func withMysteryWeapon(_ toCard: Card? = nil) -> Player {
			.init(id: id, name: name, privateCards: privateCards, mystery: mystery.withWeapon(toCard))
		}

	}

}
