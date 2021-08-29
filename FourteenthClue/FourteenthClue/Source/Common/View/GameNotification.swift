//
//  GameNotification.swift
//  Fourteenth Clue
//
//  Created by Joseph Roque on 2021-08-25.
//

import SwiftUI

struct GameNotification: Identifiable {

	let id: UUID
	let title: String
	let message: String
	let style: Style

}

extension GameNotification {
	enum Style {
		case success
		case information
		case warning
		case error

		var textColor: Color {
			switch self {
			case .success: return .white
			case .information: return .black
			case .warning: return .white
			case .error: return .white
			}
		}

		var backgroundColor: Color {
			switch self {
			case .success: return .green
			case .information: return .white
			case .warning: return .yellow
			case .error: return .red
			}
		}

	}

}

struct GameNotificationBanner: View {

	let notification: GameNotification
	let onDismiss: (() -> Void)?

	var body: some View {
		VStack(alignment: .leading) {
			Text(notification.title)
				.font(.headline)
				.frame(maxWidth: .infinity, alignment: .leading)
				.foregroundColor(notification.style.textColor)
			Text(notification.message)
				.font(.body)
				.frame(maxWidth: .infinity, alignment: .leading)
				.foregroundColor(notification.style.textColor)
		}
		.padding()
		.background(
			RoundedRectangle(cornerRadius: 16)
				.fill(notification.style.backgroundColor)
		)
		.overlay {
			if onDismiss != nil {
				VStack {
					HStack(alignment: .top) {
						Spacer()
						Image(systemName: "xmark")
							.resizable()
							.frame(width: 16, height: 16)
							.foregroundColor(notification.style.textColor)
							.onTapGesture {
								onDismiss?()
							}
					}
					.padding(.top, 16)
					Spacer()
				}
			}
		}
	}

}

struct GameNotificationBannerSection: View {

	let notification: GameNotification
	let onDismiss: (() -> Void)?

	var body: some View {
		Section {
			GameNotificationBanner(notification: notification, onDismiss: onDismiss)
		}
		.listRowBackground(notification.style.backgroundColor)
	}

}

extension GameNotificationBanner {

	func onDismiss(completionHandler: @escaping () -> Void) -> GameNotificationBanner {
		.init(
			notification: self.notification,
			onDismiss: completionHandler
		)
	}

}

#if DEBUG
struct GameNotificationBannerPreview: PreviewProvider {
	static var previews: some View {
		List {
			GameNotificationBannerSection(
				notification: GameNotification(
					id: UUID(),
					title: "Information",
					message: "An informative banner with a lot of text in it that will probably wrap to at least the second line.",
					style: .information
				)
			) { }

			GameNotificationBannerSection(
				notification: GameNotification(
					id: UUID(),
					title: "Success",
					message: "A short success banner",
					style: .success
				)
			) { }

			GameNotificationBannerSection(
				notification: GameNotification(
					id: UUID(),
					title: "Error",
					message: "Whoops",
					style: .error
				)
			) { }

			GameNotificationBannerSection(
				notification: GameNotification(
					id: UUID(),
					title: "Warning",
					message: "Watch out!",
					style: .warning
				)
			) { }
		}
	}
}
#endif
