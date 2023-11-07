

import Foundation

protocol Configurable {
    associatedtype Model
    associatedtype Settings
    func configure(with model: Model, units: Settings, at index: Int, at section: Int?, at row: Int?)
}
