

import Foundation

protocol Configurable {
    associatedtype Model
    func configure(with model: Model, at index: Int)
}
