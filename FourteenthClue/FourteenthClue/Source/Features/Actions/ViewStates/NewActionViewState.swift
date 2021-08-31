//
//  NewActionViewState.swift
//  NewActionViewState
//
//  Created by Joseph Roque on 2021-08-20.
//

import FourteenthClueKit

struct NewActionViewState {

	var enabledTypes: [ActionType]
	var type: ActionType
	var inquisition: NewInquisition
	var accusation: NewAccusation
	var examination: NewExamination

	init(state: GameState) {
		self.enabledTypes = ActionType.allCases.filter { $0.isEnabled(in: state) }
		self.type = enabledTypes.first!
		self.inquisition = NewInquisition(state: state)
		self.accusation = NewAccusation(state: state)
		self.examination = NewExamination(state: state)
	}

}

// MARK: - ActionType

extension NewActionViewState {

	enum ActionType: String, CaseIterable, Identifiable {
		case inquisition
		case accusation
		case examination

		var id: String {
			rawValue
		}

		var name: String {
			rawValue.capitalized
		}

		func isEnabled(in state: GameState) -> Bool {
			switch self {
			case .inquisition, .accusation:
				return true
			case .examination:
				return state.numberOfInformants > 0
			}
		}
	}

}

// MARK: - NewInquisition

extension NewActionViewState {

	struct NewInquisition {

		init(state: GameState) {
			self.askingPlayer = state.players.first!
			self.answeringPlayer = state.players.first!
		}

		var askingPlayer: Player
		var answeringPlayer: Player
		var type: InquisitionType = .color
		var color: Card.Color = Card.Color.allCases.first!
		var category: Card.Category = Card.Category.allCases.first!
		var includingCardOnSide: Card.HiddenCardPosition = .left
		var count: Int?

		func build(withState state: GameState) -> Inquisition? {
			guard let count = count else { return nil }

			let filter: Card.Filter
			switch type {
			case .color:
				filter = .color(color)
			case .category:
				filter = .category(category)
			}

			return Inquisition(
				ordinal: state.actions.count,
				askingPlayer: askingPlayer.name,
				answeringPlayer: answeringPlayer.name,
				filter: filter,
				includingCardOnSide: state.numberOfPlayers == 2 ? includingCardOnSide : nil,
				count: count
			)
		}
	}

}

extension NewActionViewState.NewInquisition {

	enum InquisitionType: String, CaseIterable, Identifiable {
		case color
		case category

		var id: String {
			rawValue
		}

		var name: String {
			rawValue.capitalized
		}
	}

}

// MARK: - NewAccusation

extension NewActionViewState {

	struct NewAccusation {

		init(state: GameState) {
			self.accusingPlayer = state.players.first!
		}

		var accusingPlayer: Player
		var person: Card = Card.peopleCards.sorted().first!
		var location: Card = Card.locationsCards.sorted().first!
		var weapon: Card = Card.weaponsCards.sorted().first!
		var pickingCardPosition: Card.Position?

		func build(withState state: GameState) -> Accusation {
			Accusation(
				ordinal: state.actions.count,
				accusingPlayer: accusingPlayer.name,
				accusation: MysteryCardSet(
					person: person,
					location: location,
					weapon: weapon
				)
			)
		}
	}

}

// MARK: - NewExamination

extension NewActionViewState {

	struct NewExamination {

		init(state: GameState) {
			self.examiningPlayer = state.players.first!
			self.informant = state.secretInformants.first?.name ?? ""
		}

		var examiningPlayer: Player
		var informant: String

		func build(withState state: GameState) -> Examination {
			Examination(
				ordinal: state.actions.count,
				player: examiningPlayer.name,
				informant: informant
			)
		}

	}

}
