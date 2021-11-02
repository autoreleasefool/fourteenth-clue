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
		var property: Card.Property = Card.Property.allCases.first!
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
			self.informant = state.secretInformants.first!
		}

		var examiningPlayer: Player
		var informant: SecretInformant

		func build(withState state: GameState) -> Examination {
			Examination(
				ordinal: state.actions.count,
				player: examiningPlayer.name,
				informant: informant.name
			)
		}

	}

}

extension NewActionViewState {

	static func from(action: PotentialAction, state: GameState) -> NewActionViewState {
		switch action {
		case .inquiry(let inquiry):
			return startInquisition(inquiry, state: state)
		case .informing(let informing):
			return startExamination(informing, state: state)
		}
	}

	static func startAccusation(_ accusation: Accusation, state: GameState) -> NewActionViewState {
		var viewState = NewActionViewState(state: state)
		viewState.type = .accusation
		viewState.accusation = .init(state: state)
		viewState.accusation.accusingPlayer = state.players.first!
		viewState.accusation.person = accusation.accusation.person!
		viewState.accusation.location = accusation.accusation.location!
		viewState.accusation.weapon = accusation.accusation.weapon!
		return viewState
	}

	static func startAccusation(_ solution: Solution, state: GameState) -> NewActionViewState {
		var viewState = NewActionViewState(state: state)
		viewState.type = .accusation
		viewState.accusation = .init(state: state)
		viewState.accusation.accusingPlayer = state.players.first!
		viewState.accusation.person = solution.person
		viewState.accusation.location = solution.location
		viewState.accusation.weapon = solution.weapon
		return viewState
	}

	static func startInquisition(_ inquiry: Inquiry, state: GameState) -> NewActionViewState {
		var viewState = NewActionViewState(state: state)
		viewState.type = .inquisition
		viewState.inquisition = .init(state: state)
		viewState.inquisition.askingPlayer = state.players.first!
		viewState.inquisition.answeringPlayer = state.players.first { $0.name == inquiry.player }!
		switch inquiry.filter {
		case .color(let color):
			viewState.inquisition.type = .color
			viewState.inquisition.color = color
		case .category(let category):
			viewState.inquisition.type = .category
			viewState.inquisition.category = category
		}

		viewState.inquisition.includingCardOnSide = inquiry.includingCardOnSide ?? .left
		return viewState
	}

	static func startExamination(_ informing: Informing, state: GameState) -> NewActionViewState {
		var viewState = NewActionViewState(state: state)
		viewState.type = .examination
		viewState.examination = .init(state: state)
		viewState.examination.examiningPlayer = state.players.first!
		viewState.examination.informant = state.secretInformants.first { $0.name == informing.informant }!
		return viewState
	}

}
