import UIKit

public protocol IAssembly {
	var module: Module { get }
	var isAuthorizationRequired: Bool { get }
	var isAuthenticationRequired: Bool { get }
	var canHandleDeeplink: Bool { get }
	var isRegistrationDeeplink: Bool { get }
	func build(with parameters: [String: Any]?) throws -> UIViewController
}

extension IAssembly {
	
	public var isAuthorizationRequired: Bool {
		return false
	}

	public var canHandleDeeplink: Bool {
		return true
	}
	
	public var isAuthenticationRequired: Bool {
		return false
	}
	
	public var isRegistrationDeeplink: Bool {
		return false
	}
}
