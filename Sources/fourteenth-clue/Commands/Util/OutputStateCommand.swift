//
//  OutputStateCommand.swift
//  FourteenthClue
//
//  Created by Joseph Roque on 2021-08-18.
//

struct OutputStateCommand: RunnableCommand {

	static var help: String {
		"show: show the current state of the game"
	}

	static let unknown = "Unknown"

	init?(_ string: String) {
		guard string == "show" else { return nil }
	}

	func run(_ state: EngineState) throws {
		print("=Players=")
		state.gameState.players.forEach {
			print("\t\($0.name)")
			print("""
					Mystery: \
			\($0.mystery.person?.name ?? Self.unknown), \
			\($0.mystery.location?.name ?? Self.unknown), \
			\($0.mystery.weapon?.name ?? Self.unknown)
			""")
			print("""
					Hidden: \
			\($0.hidden.left?.name ?? Self.unknown), \
			\($0.hidden.right?.name ?? Self.unknown)
			""")
		}

		if !state.gameState.secretInformants.isEmpty {
			print("=Informants=")
			state.gameState.secretInformants.forEach {
				print("\t\($0.name): \($0.card?.name ?? Self.unknown)")
			}
		}

		if !state.gameState.actions.isEmpty {
			print("=Actions=")
			state.gameState.actions.forEach {
				print("\t\($0.description(withState: state.gameState))")
			}
		}
	}
}
