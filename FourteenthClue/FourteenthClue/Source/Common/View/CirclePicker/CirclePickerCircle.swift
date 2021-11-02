//
//  CirclePickerCircle.swift
//  Fourteenth Clue
//
//  Created by Joseph Roque on 2021-10-30.
//

import SwiftUI

struct CirclePickerCircle<Content: View>: View {

	var isSelected: Bool

	@ViewBuilder
	var content: () -> Content

	var body: some View {
		self.content()
			.frame(width: 44, height: 44)
			.clipShape(Circle())
			.applyThinBorder(if: !isSelected)
			.applyThickBorder(if: isSelected)
	}
}

private extension View {

	@ViewBuilder
	func applyThinBorder(if shouldApply: Bool) -> some View {
		if shouldApply {
			self.overlay(
				Circle()
					.stroke(.gray, lineWidth: 1)
			)
		} else {
			self
		}
	}

	@ViewBuilder
	func applyThickBorder(if shouldApply: Bool) -> some View {
		if shouldApply {
			self.overlay(
				Circle()
					.stroke(.black, lineWidth: 2)
			)
		} else {
			self
		}
	}

}
