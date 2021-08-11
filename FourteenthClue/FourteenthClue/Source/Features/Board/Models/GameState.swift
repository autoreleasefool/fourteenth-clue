//
//  GameState.swift
//  Fourteenth Clue
//
//  Created by Joseph Roque on 2021-06-23.
//

import SwiftUI

struct GameState {

	let id = UUID()
	let players: [Player]
	let secretInformants: [SecretInformant]
	let cards: Set<Card>
	let clues: [AnyClue]

	init(playerCount: Int) {
		self.init(
			players: (0..<playerCount).map { _ in .default },
			secretInformants: GameState.secretInformants(forPlayerCount: playerCount),
			clues: [],
			cards: Card.cardSet(forPlayerCount: playerCount)
		)
	}

	init(playerNames: [String]) {
		self.init(
			players: playerNames.map {
				Player(
					name: $0,
					privateCards: PrivateCardSet(),
					mystery: MysteryCardSet()
				)
			},
			secretInformants: GameState.secretInformants(forPlayerCount: playerNames.count),
			clues: [],
			cards: Card.cardSet(forPlayerCount: playerNames.count)
		)
	}

	init?(playerNames: [String], playerIDs: [String], seed: String) {
		guard let data = seed.data(using: .utf8),
					let seedState = try? JSONDecoder().decode(SeedState.self, from: data)
		else {
			return nil
		}

		self.init(
			players: zip(playerNames, playerIDs)
				.enumerated()
				.map { index, nameAndID in
					let (name, id) = nameAndID
					let seed = seedState[id]!.compactMap { Card(fromSeed: $0.name) }

					if seed.count == 2 {
						return Player(
							id: id,
							name: name,
							privateCards: PrivateCardSet(
								leftCard: seed.first!,
								rightCard: seed.last!
							),
							mystery: MysteryCardSet()
						)
					} else {
						let seedSet = Set(seed)

						return Player(
							id: id,
							name: name,
							privateCards: PrivateCardSet(),
							mystery: MysteryCardSet(
								person: seedSet.people.first!,
								location: seedSet.locations.first!,
								weapon: seedSet.weapons.first!
							)
						)
					}
				},
			secretInformants: GameState.secretInformants(forPlayerCount: playerNames.count),
			clues: [],
			cards: Card.cardSet(forPlayerCount: playerNames.count)
		)
	}

	init?(seed: String) {
		guard let data = seed.data(using: .utf8),
					let seedState = try? JSONDecoder().decode(SeedState.self, from: data)
		else {
			return nil
		}

		let firstPlayerSeed = seedState
			.first(where: { $0.value.count == 2 })!
		let firstPlayerCards = firstPlayerSeed.value.compactMap { Card(fromSeed: $0.name) }
		let otherSeeds = seedState.filter { $0.value.count == 3 }

		self.init(
			players: [
				Player(
					id: firstPlayerSeed.key,
					name: "",
					privateCards: PrivateCardSet(
						leftCard: firstPlayerCards.first!,
						rightCard: firstPlayerCards.last!
					),
					mystery: MysteryCardSet()
				)
			] + otherSeeds.map {
				let cards = Set($0.value.compactMap { Card(fromSeed: $0.name) })
				return Player(
					id: $0.key,
					name: "",
					privateCards: PrivateCardSet(),
					mystery: MysteryCardSet(
						person: cards.people.first!,
						location: cards.locations.first!,
						weapon: cards.weapons.first!
					)
				)
			},
			secretInformants: GameState.secretInformants(forPlayerCount: seedState.count),
			clues: [],
			cards: Card.cardSet(forPlayerCount: seedState.count)
		)
	}

	private init(players: [Player], secretInformants: [SecretInformant], clues: [AnyClue], cards: Set<Card>) {
		self.players = players
		self.secretInformants = secretInformants
		self.clues = clues
		self.cards = cards
	}

	static func secretInformants(forPlayerCount playerCount: Int) -> [SecretInformant] {
		(0..<8 - ((playerCount - 2) * 2)).map { _ in .default }
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

	func addingClue(_ clue: AnyClue) -> GameState {
		.init(players: players, secretInformants: secretInformants, clues: clues + [clue], cards: cards)
	}

	func removingClue(_ clue: AnyClue) -> GameState {
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

	var numberOfPlayers: Int {
		players.count
	}

	var numberOfInformants: Int {
		secretInformants.count
	}

	func cardsVisible(toPlayer targetPlayer: Player) -> Set<Card> {
		Set(players.flatMap { player in
			return targetPlayer.id == player.id
				? player.privateCards.cards
				: player.mystery.cards
		})
	}

	func mysteryCardsVisibleToMe(excludingPlayer excludedPlayer: String) -> Set<Card> {
		players.dropFirst()
			.reduce(into: Set<Card>()) { cards, player in
				guard player.id != excludedPlayer else { return }
				cards.formUnion(player.mystery.cards)
			}
	}

	func cards(forFilter filter: Inquisition.Filter) -> Set<Card> {
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

	var initialUnknownCards: Set<Card> {
		cards
			.subtracting(players.first!.privateCards.cards)
			.subtracting(players.dropFirst().flatMap { $0.mystery.cards })
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

// MARK: Examples

extension GameState {

	var example1: GameState {
		.init(
			players: [
				.init(
					name: "Me",
					privateCards: .init(leftCard: .butcher, rightCard: .dancer),
					mystery: .init(person: nil, location: nil, weapon: nil)
//					mystery: .init(person: .nurse, location: .parlor, weapon: .gun)
				),
				.init(
					name: "Player 2",
					privateCards: .init(leftCard: nil, rightCard: nil),
//					privateCards: .init(leftCard: .plaza, rightCard: .crossbow),
					mystery: .init(person: .officer, location: .market, weapon: .sword)
				),
				.init(
					name: "Player 3",
					privateCards: .init(leftCard: nil, rightCard: nil),
//					privateCards: .init(leftCard: .library, rightCard: .rifle),
					mystery: .init(person: .duke, location: .harbor, weapon: .blowgun)
				),
				.init(
					name: "Player 4",
					privateCards: .init(leftCard: nil, rightCard: nil),
//					privateCards: .init(leftCard: .museum, rightCard: .theater),
					mystery: .init(person: .maid, location: .park, weapon: .candlestick)
				),
			],
			secretInformants: [
				.init(card: nil),
				.init(card: nil),
				.init(card: nil),
				.init(card: nil),
//				.init(card: .sailor),
//				.init(card: .countess),
//				.init(card: .knife),
//				.init(card: .poison),
			],
			clues: [
			],
			cards: Card.cardSet(forPlayerCount: 4)
		)
	}

}
