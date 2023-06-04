import UIKit

public protocol ITransition {
	var name: String { get }
	var parameters: [String: Any]? { get }
}

public struct Transition: ITransition {
	public let name: String
	public let parameters: [String: Any]?
	
	public init(name: String, parameters: [String: Any]? = nil) {
		self.name = name
		guard let unwrapParameters = parameters else {
			self.parameters = parameters
			return
		}
		var newParameters = [String: AnyObject]()
		newParameters = unwrapParameters.compactMapValues { $0.self as AnyObject }
		self.parameters = newParameters
	}
}

public struct FlipTransition: ITransition {
	public let name: String
	public let parameters: [String: Any]?
	public weak var fromViewContoller: UIViewController?
	
	public init(name: String, parameters: [String: Any]?, fromViewContoller: UIViewController?) {
		self.name = name
		self.parameters = parameters
		self.fromViewContoller = fromViewContoller
	}
}

public typealias TransitionCompletionBlock = () -> Void

public enum TransitionType {
	case tab(ITransition)
	case push(ITransition)
	case pop(UIViewController?)
	case popFrom(UIViewController, to: UIViewController)
	case present(ITransition)
	case presentPageSheet(ITransition)
	case presentDismissablePageSheet(ITransition)
	case presentPageSheetAlert(ITransition)
	case presentPageSheetDialogue(ITransition)
	case presentPageSheetEmbedded(ITransition)
	case presentFullScreen(ITransition)
	case presentFullScreenCrossDissolve(ITransition)
	case cardFlip(ITransition)
	case presentOverCurrentContext(ITransition)
	case dismiss(TransitionCompletionBlock?)
}
