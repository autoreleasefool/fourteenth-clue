//
//  CardImage.swift
//  Fourteenth Clue
//
//  Created by Joseph Roque on 2021-07-08.
//

import SwiftUI

struct CardImage: View {

	let card: Card?
	let showingName: Bool
	let overrideName: String?
	let size: Size

	init(card: Card?) {
		self.init(
			card: card,
			showingName: false,
			overrideName: nil,
			size: .original
		)
	}

	private init(card: Card?, showingName: Bool, overrideName: String?, size: Size) {
		self.card = card
		self.showingName = showingName
		self.overrideName = overrideName
		self.size = size
	}

	var body: some View {
		HStack {
			Image(uiImage: card?.image ?? Assets.Images.Cards.back)
				.resizable()
				.clipShape(RoundedRectangle(cornerRadius: 8))
				.frame(width: size.width, height: size.height)

			if let name = card?.name ?? overrideName, showingName {
				Text(name)
			}
		}
	}

}

extension CardImage {

	enum Size {

		case small
		case medium
		case large
		case original

		var width: CGFloat {
			switch self {
			case .small: return 40
			case .medium: return 60
			case .large: return 80
			case .original: return 120
			}
		}

		var height: CGFloat {
			switch self {
			case .small: return 66
			case .medium: return 100
			case .large: return 132
			case .original: return 200
			}
		}

	}

}

// MARK: - Modifiers

extension CardImage {

	func showingCardName() -> CardImage {
		CardImage(card: card, showingName: true, overrideName: nil, size: size)
	}

	func overridingNilName(with overrideName: String?) -> CardImage {
		CardImage(card: card, showingName: showingName, overrideName: overrideName, size: size)
	}

	func size(_ size: Size) -> CardImage {
		CardImage(card: card, showingName: showingName, overrideName: overrideName, size: size)
	}
}
