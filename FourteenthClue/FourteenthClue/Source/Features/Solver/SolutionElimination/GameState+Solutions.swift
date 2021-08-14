//
//  GameState+Solutions.swift
//  GameState+Solutions
//
//  Created by Joseph Roque on 2021-08-02.
//

extension GameState {

	func allPossibleSolutions() -> [Solution] {
		let me = players.first!
		let cardsForSolutions = unallocatedCards

		let possiblePeople = me.mystery.person != nil
			? [me.mystery.person!]
			: cardsForSolutions.people

		let possibleLocations = me.mystery.location != nil
			? [me.mystery.location!]
			: cardsForSolutions.locations

		let possibleWeapons = me.mystery.weapon != nil
			? [me.mystery.weapon!]
			: cardsForSolutions.weapons

		return possiblePeople.flatMap { person in
			possibleLocations.flatMap { location in
				possibleWeapons.map { weapon in
					Solution(
						person: person,
						location: location,
						weapon: weapon,
						probability: 0
					)
				}
			}
		}
	}

}

//
//var initialGameStateForCopy = null;
//var orig = gameui.notif_onCombinaisonAssigned;
//gameui.notif_onCombinaisonAssigned = function (e) {
//        try {
//                console.log(e.args.visible_cards_players);
//                initialGameStateForCopy = JSON.stringify(e.args.visible_cards_players);
//                console.log(initialGameStateForCopy)
//                orig.call(this, e);
//        } catch (e) {
//                console.log("joseph" + e);
//        }
//}
//
//

// 2 Players
/*
{
	"85268622":[{"name":"Officer"},{"name":"Sword"},{"name":"Park"}],
	"88584546":[{"name":"Butcher"},{"name":"Nurse"}]
}
*/

// 3 Players
/*
{
	"85268622":[{"name":"Officer"},{"name":"Sword"},{"name":"Park"}],
	"87792535":[{"name":"Duke"},{"name":"Harbor"},{"name":"Blowgun"}],
	"88584546":[{"name":"Butcher"},{"name":"Countess"}]
}
*/

// 4 Players
/*
{
	"85268622":[{"name":"Officer"},{"name":"Sword"},{"name":"Park"}],
	"87792535":[{"name":"Duke"},{"name":"Harbor"},{"name":"Blowgun"}],
	"87978988":[{"name":"Countess"},{"name":"Library"},{"name":"Knife"}],
	"88584546":[{"name":"Butcher"},{"name":"Nurse"}]
}
*/

// 5 Players
/*
{
	"85268622":[{"name":"Officer"},{"name":"Sword"},{"name":"Park"}],
	"87792535":[{"name":"Duke"},{"name":"Harbor"},{"name":"Blowgun"}],
	"87978988":[{"name":"Countess"},{"name":"Library"},{"name":"Knife"}],
	"43278232":[{"name":"Dancer"},{"name":"Theater"},{"name":"Poison"}],
	"88584546":[{"name":"Butcher"},{"name":"Nurse"}]
}
*/

// 6 Players
/*
{
	"85268622":[{"name":"Officer"},{"name":"Sword"},{"name":"Park"}],
	"87792535":[{"name":"Duke"},{"name":"Harbor"},{"name":"Blowgun"}],
	"87978988":[{"name":"Countess"},{"name":"Library"},{"name":"Knife"}],
	"43278232":[{"name":"Dancer"},{"name":"Theater"},{"name":"Poison"}],
	"71239847":[{"name":"Florist"},{"name":"Racecourse"},{"name":"Gun"}],
	"88584546":[{"name":"Butcher"},{"name":"Nurse"}]
}
*/

/*
{
"Joseph": [{"name": "Plaza"},{"name":"Rifle"}],
"Aaron": [{"name":"Officer"},{"name": "Harbor"},{"name": "Blowgun"}],
"Jessica": [{"name":"Duke"},{"name": "Library"},{"name": "Sword"}],
"Cam": [{"name":"Dancer"},{"name": "Park"},{"name": "Crossbow"}],
}
 */
