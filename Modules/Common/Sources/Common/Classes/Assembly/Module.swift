import Foundation

public struct Module {
	public let name: String
	
	public init(name: String) {
		self.name = name
	}
}

extension Module: Hashable {
	public static func == (lhs: Module, rhs: Module) -> Bool {
		return lhs.name == rhs.name
	}

	public func hash(into hasher: inout Hasher) {
		hasher.combine(name)
	}
}
