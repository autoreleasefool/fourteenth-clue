//
//  LoafState.swift
//  LoafState
//
//  Created by Joseph Roque on 2021-08-10.
//

import UIKit
import Loaf
import SwiftUI

struct LoafState: Hashable, Equatable {
	private static var lastId = 0
	private static func nextId() -> Int {
		lastId += 1
		return lastId
	}

	private let id: Int
	let message: String
	let style: Style
	let location: Loaf.Location
	let presentingDirection: Loaf.Direction
	let dismissingDirection: Loaf.Direction
	let duration: Loaf.Duration?
	let onDismiss: Loaf.LoafCompletionHandler

	init(
		_ message: String,
		style: Style = .info(),
		location: Loaf.Location = .bottom,
		presentingDirection: Loaf.Direction = .vertical,
		dismissingDirection: Loaf.Direction = .vertical,
		duration: Loaf.Duration? = nil,
		onDismiss: Loaf.LoafCompletionHandler = nil
	) {
		self.id = Self.nextId()
		self.message = message
		self.style = style
		self.location = location
		self.presentingDirection = presentingDirection
		self.dismissingDirection = dismissingDirection
		self.duration = duration
		self.onDismiss = onDismiss
	}

	func show(withSender sender: UIViewController) {
		Loaf(
			message,
			state: .custom(style.build()),
			location: location,
			presentingDirection: presentingDirection,
			dismissingDirection: dismissingDirection,
			sender: sender
		).show(duration ?? .average, completionHandler: onDismiss)
	}

	func build() -> Loaf {
		Loaf(
			message,
			state: .custom(style.build()),
			location: location,
			presentingDirection: presentingDirection,
			dismissingDirection: dismissingDirection,
			duration: duration ?? .average
		)
	}

	static func == (lhs: Self, rhs: Self) -> Bool {
		lhs.id == rhs.id
	}

	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}
}

// MARK: - Style
extension LoafState {
	struct Style {
		let backgroundColor: Color
		let textColor: Color
		let icon: UIImage?

		init(
			backgroundColor: Color,
			textColor: Color,
			icon: UIImage?
		) {
			self.backgroundColor = backgroundColor
			self.textColor = textColor
			self.icon = icon
		}

		func build() -> Loaf.Style {
			Loaf.Style(
				backgroundColor: UIColor(backgroundColor),
				textColor: UIColor(textColor),
				icon: icon
			)
		}

		static func info() -> Self {
			Style(
				backgroundColor: .mint,
				textColor: .white,
				icon: Loaf.Icon.info
			)
		}

//		static func error() -> Self {
//			Style(
//				backgroundColor: .highlightDestructive,
//				textColor: .textRegular,
//				icon: Loaf.Icon.error
//			)
//		}
//
//		static func success() -> Self {
//			Style(
//				backgroundColor: .highlightSuccess,
//				textColor: .textRegular,
//				icon: Loaf.Icon.success
//			)
//		}
//
//		static func warning() -> Self {
//			Style(
//				backgroundColor: .highlightRegular,
//				textColor: .textRegular,
//				icon: Loaf.Icon.warning
//			)
//		}
	}
}
