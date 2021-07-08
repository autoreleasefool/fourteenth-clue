//
//  NavigationLink+Extensions.swift
//  Fourteenth Clue
//
//  Created by Joseph Roque on 2021-07-07.
//

import SwiftUI

extension NavigationLink where Label == EmptyView {

	init?<Value>(
		_ binding: Binding<Value?>,
		@ViewBuilder destination: (Value) -> Destination
	) {
		guard let value = binding.wrappedValue else {
			return nil
		}

		let isActive = Binding(
			get: { true },
			set: { newValue in
				if !newValue {
					binding.wrappedValue = nil
				}
			}
		)

		self.init(destination: destination(value), isActive: isActive, label: EmptyView.init)
	}

}

extension View {

	@ViewBuilder
	func navigate<Value, Destination: View>(
		using binding: Binding<Value?>,
		@ViewBuilder destination: (Value) -> Destination
	) -> some View {
		background(NavigationLink(binding, destination: destination))
	}

}
