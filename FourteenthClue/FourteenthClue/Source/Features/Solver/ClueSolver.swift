//
//  ClueSolver.swift
//  Fourteenth Clue
//
//  Created by Joseph Roque on 2021-06-22.
//

import Combine
import Foundation

protocol ClueSolver {
	var state: GameState? { get set }
	var solutions: AnyPublisher<[Solution], Never> { get }
}

