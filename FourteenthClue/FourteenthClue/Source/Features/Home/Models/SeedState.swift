//
//  SeedState.swift
//  Fourteenth Clue
//
//  Created by Joseph Roque on 2021-07-07.
//

import Foundation

typealias SeedState = [String: [CardSeed]]

struct CardSeed: Codable {
	let name: String
}


//
//	{
//		"83959368": [
//			{
//				"name":"Park",
//				"type":"Location",
//				"subtype":"Outdoor",
//				"color":"Green",
//				"id":"3",
//				"type_arg":"14"
//			},
//			{
//				"name":"Candlestick",
//			"type":"Weapon",
//			"subtype":"Up Close",
//			"color":"White",
//			"id":"14",
//			"type_arg":"28"
//
//		},
//		{
//			"name":"Maid",
//			"type":"Person",
//			"subtype":"Female",
//			"color":"Blue",
//			"id":"18",
//			"type_arg":"6"
//		}
//		],"85268622":[{"name":"Officer","type":"Person","subtype":"Male","color":"Purple","id":"9","type_arg":"1"},{"name":"Sword","type":"Weapon","subtype":"Up Close","color":"Green","id":"12","type_arg":"24"},{"name":"Market","type":"Location","subtype":"Outdoor","color":"Pink","id":"16","type_arg":"12"}],"87792535":[{"name":"Duke","type":"Person","subtype":"Male","color":"Pink","id":"5","type_arg":"2"},{"name":"Harbor","type":"Location","subtype":"Outdoor","color":"Blue","id":"8","type_arg":"16"},{"name":"Blowgun","type":"Weapon","subtype":"Ranged","color":"Yellow","id":"10","type_arg":"25"}],"88584546":[{"name":"Butcher","type":"Person","subtype":"Male","color":"Red","id":"2","type_arg":"3"},{"name":"Dancer","type":"Person","subtype":"Female","color":"Orange","id":"7","type_arg":"7"}]}
