//
//  GameState.swift
//  Fourteenth Clue
//
//  Created by Joseph Roque on 2021-06-23.
//

import SwiftUI

struct GameState {

	let players: [Player]
	let secretInformants: [SecretInformant]
	let cards: Set<Card>
	let clues: [Clue]

	init(playerCount: Int) {
		self.players = (0..<playerCount).map { _ in .default }
		self.secretInformants = (0..<8 - ((playerCount - 2) * 2)).map { _ in .default }
		self.clues = []

		var availableCards = Set(Card.allCases)
		switch playerCount {
		case 2:
			availableCards = availableCards.subtracting(Card.orangeCards)
			fallthrough
		case 3:
			availableCards = availableCards.subtracting(Card.whiteCards)
			fallthrough
		case 4:
			availableCards = availableCards.subtracting(Card.brownCards)
			fallthrough
		case 5:
			availableCards = availableCards.subtracting(Card.grayCards)
		default:
			break
		}

		self.cards = availableCards
	}

	private init(players: [Player], secretInformants: [SecretInformant], clues: [Clue], cards: Set<Card>) {
		self.players = players
		self.secretInformants = secretInformants
		self.clues = clues
		self.cards = cards
	}

	// MARK: Mutations

	func withPlayer(_ player: Player) -> GameState {
		guard let index = players.firstIndex(where: { $0.id == player.id }) else { return self }
		var updatedPlayers = players
		updatedPlayers[index] = player
		return .init(players: updatedPlayers, secretInformants: secretInformants, clues: clues, cards: cards)
	}

	func withSecretInformant(_ informant: SecretInformant) -> GameState {
		guard let index = secretInformants.firstIndex(where: { $0.id == informant.id }) else { return self }
		var updatedInformants = secretInformants
		updatedInformants[index] = informant
		return .init(players: players, secretInformants: updatedInformants, clues: clues, cards: cards)
	}

	func addingClue(_ clue: Clue) -> GameState {
		.init(players: players, secretInformants: secretInformants, clues: clues + [clue], cards: cards)
	}

	func removingClue(_ clue: Clue) -> GameState {
		guard let clueIndex = self.clues.firstIndex(of: clue) else { return self }
		var clues = self.clues
		clues.remove(at: clueIndex)
		return .init(players: players, secretInformants: secretInformants, clues: clues, cards: cards)
	}

	func removingClues(atOffsets offsets: IndexSet) -> GameState {
		var clues = self.clues
		clues.remove(atOffsets: offsets)
		return .init(players: players, secretInformants: secretInformants, clues: clues, cards: cards)
	}

	// MARK: Properties

	func cardsVisible(toPlayer targetPlayer: Player) -> Set<Card> {
		Set(players.flatMap { player in
			return targetPlayer.id == player.id
				? player.privateCards.cards
				: player.mystery.cards
		})
	}

	func cards(forFilter filter: Clue.Filter) -> Set<Card> {
		switch filter {
		case .color(let color):
			switch color {
			case .purple: return purpleCards
			case .pink: return pinkCards
			case .red: return redCards
			case .green: return greenCards
			case .yellow: return yellowCards
			case .blue: return blueCards
			case .orange: return orangeCards
			case .white: return whiteCards
			case .brown: return brownCards
			case .gray: return grayCards
			}
		case .category(let category):
			switch category {
			case .person(.man): return menCards
			case .person(.woman): return womenCards
			case .location(.indoors): return indoorsCards
			case .location(.outdoors): return outdoorsCards
			case .weapon(.melee): return meleeCards
			case .weapon(.ranged): return rangedCards
			}
		}
	}

	// MARK: - Cards

	var unallocatedCards: Set<Card> {
		cards
			.subtracting(players.flatMap { $0.mystery.cards })
			.subtracting(players.flatMap { $0.privateCards.cards })
			.subtracting(secretInformants.compactMap { $0.card })
	}

	var allCards: Set<Card> {
		cards
	}

	var purpleCards: Set<Card> { cards.intersection(Card.purpleCards) }
	var pinkCards: Set<Card> { cards.intersection(Card.pinkCards) }
	var redCards: Set<Card> { cards.intersection(Card.redCards) }
	var greenCards: Set<Card> { cards.intersection(Card.greenCards) }
	var yellowCards: Set<Card> { cards.intersection(Card.yellowCards) }
	var blueCards: Set<Card> { cards.intersection(Card.blueCards) }
	var orangeCards: Set<Card> { cards.intersection(Card.orangeCards) }
	var whiteCards: Set<Card> { cards.intersection(Card.whiteCards) }
	var brownCards: Set<Card> { cards.intersection(Card.brownCards) }
	var grayCards: Set<Card> { cards.intersection(Card.grayCards) }

	// MARK: People

	var peopleCards: Set<Card> { cards.intersection(Card.peopleCards) }
	var menCards: Set<Card> { cards.intersection(Card.menCards) }
	var womenCards: Set<Card> { cards.intersection(Card.womenCards) }

	// MARK: Locations

	var locationsCards: Set<Card> { cards.intersection(Card.locationsCards) }
	var outdoorsCards: Set<Card> { cards.intersection(Card.outdoorsCards) }
	var indoorsCards: Set<Card> { cards.intersection(Card.indoorsCards) }

	// MARK: Weapons

	var weaponsCards: Set<Card> { cards.intersection(Card.weaponsCards) }
	var rangedCards: Set<Card> { cards.intersection(Card.rangedCards) }
	var meleeCards: Set<Card> { cards.intersection(Card.meleeCards) }

}
