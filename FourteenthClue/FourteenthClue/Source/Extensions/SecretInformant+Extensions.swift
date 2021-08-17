//
//  SecretInformant+Extensions.swift
//  SecretInformant+Extensions
//
//  Created by Joseph Roque on 2021-08-17.
//

import Foundation
import FourteenthClueKit

extension SecretInformant: Identifiable {

	public var id: String {
		name
	}

}
