//
//  GameState+Player.swift
//  Fourteenth Clue
//
//  Created by Joseph Roque on 2021-06-27.
//

extension GameState {

	struct Player {

		let name: String
		let privateCards: PrivateCardSet
		let mystery: MysteryCardSet

		static var `default`: Player {
			.init(name: "", privateCards: PrivateCardSet(), mystery: MysteryCardSet())
		}

		init(name: String, privateCards: PrivateCardSet, mystery: MysteryCardSet) {
			self.name = name
			self.privateCards = privateCards
			self.mystery = mystery
		}

		// MARK: Mutations

		func withName(_ newName: String) -> Player {
			.init(name: newName, privateCards: privateCards, mystery: mystery)
		}

		func withPrivateCard(onLeft: Card? = nil) -> Player {
			.init(name: name, privateCards: privateCards.withCard(onLeft: onLeft), mystery: mystery)
		}

		func withPrivateCard(onRight: Card? = nil) -> Player {
			.init(name: name, privateCards: privateCards.withCard(onRight: onRight), mystery: mystery)
		}

		func withMysteryPerson(_ toCard: Card? = nil) -> Player {
			.init(name: name, privateCards: privateCards, mystery: mystery.withPerson(toCard))
		}

		func withMysteryLocation(_ toCard: Card? = nil) -> Player {
			.init(name: name, privateCards: privateCards, mystery: mystery.withLocation(toCard))
		}

		func withMysteryWeapon(_ toCard: Card? = nil) -> Player {
			.init(name: name, privateCards: privateCards, mystery: mystery.withWeapon(toCard))
		}

	}

}
