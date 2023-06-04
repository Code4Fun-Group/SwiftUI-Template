import Foundation

public protocol IApplicationTransitionCoordinator {
	func navigate(_ transitionType: TransitionType, animated: Bool) throws
}
