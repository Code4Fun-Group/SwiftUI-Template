import UIKit

public protocol IRouter {}

public extension IRouter {
	var transitionCoordinator: IApplicationTransitionCoordinator? {
		return AssemblyContainer.shared.transitionCoordinator
	}
}

public extension IRouter {
	func navigate(to transitionType: TransitionType, animated: Bool) {
		do {
			try transitionCoordinator?.navigate(transitionType, animated: animated)
		} catch {
			let routerError = error
			print(routerError)
		}
	}
	
	func resetRootView(moduleName: String) {
		do {
			let viewController = try AssemblyContainer.shared.resolve(Transition(name: moduleName))
			
			if let window = UIApplication.shared.windows.first {
				window.rootViewController = viewController
			}
		} catch {
			assertionFailure("AssemblyNotFound")
		}
	}
	
	func alert(title: String?, message: String?) {
		let parameters: [String: Any] = ["title": title as Any, "message": message as Any]
		let transition = Transition(name: "customInformationAlert", parameters: parameters)
		try? transitionCoordinator?.navigate(.presentFullScreenCrossDissolve(transition), animated: true)
	}
	
	func authorizationDidComplete() {
		if AssemblyContainer.shared.returnToTransition != nil {
			self.returnToTransition()
		}
	}
	
	func resetReturnToTransition() {
		AssemblyContainer.shared.returnToTransition = nil
		AssemblyContainer.shared.setAuthorizationInProgressComplete()
		AssemblyContainer.shared.setWorkInProgressComplete()
	}
	
	func returnToTransition() {
		if let returnToTransition = AssemblyContainer.shared.returnToTransition {
			switch returnToTransition.name {
			case "qrCodeHomePage":
				navigate(to: .present(returnToTransition), animated: true)
			case "deliveryMethod":
				navigate(to: .presentPageSheetAlert(returnToTransition), animated: true)
			case "searchDeliveryAddress":
				navigate(to: .presentPageSheet(returnToTransition), animated: true)
			default:
				navigate(to: .push(returnToTransition), animated: true)
			}
		}
	}
}
