import UIKit

public protocol IAuthorizationEvaluator {
	func evaluate() -> Bool
}

public protocol IAuthenticationEvaluator {
	func evaluate() -> Bool
}

public protocol ILoginEvaluator {
	func evaluate() -> Bool
}

public class AssemblyContainer {
	public static let shared = AssemblyContainer()
	public var transitionCoordinator: IApplicationTransitionCoordinator?
	public var modules: [Module: IAssembly] = [:]
	public var returnToTransition: ITransition?
	public var isAuthorizationInProgress: Bool = false
	public var isWorkInProgress: Bool = false
	
	var assemblyForAuthorization: IAssembly?
	var assemblyForAuthentication: IAssembly?
	var assemblyForRegistrationDeeplink: IAssembly?
	var assemblyForLogin: IAssembly?
	
	var authorizationEvaluator: IAuthorizationEvaluator?
	var authenticationEvaluator: IAuthenticationEvaluator?
	var loginEvaluator: ILoginEvaluator?
	var canHandleDeeplink: Bool = true
}

extension AssemblyContainer {
	public static func register(_ assemblies: IAssembly...) {
		assemblies.forEach { assembly in
			shared.modules[assembly.module] = assembly
		}
	}
	
	public static func registerAuthorizationAssembly(assembly: IAssembly) {
		shared.assemblyForAuthorization = assembly
	}
	
	public static func registerAuthenticationAssembly(assembly: IAssembly) {
		shared.assemblyForAuthentication = assembly
	}
	
	public static func registerRegistrationDeeplinkAssembly(assembly: IAssembly) {
		shared.assemblyForRegistrationDeeplink = assembly
	}
	
	public static func registerLoginAssembly(assembly: IAssembly) {
		shared.assemblyForLogin = assembly
	}
	
	public static func setAuthorizationEvaluator(_ evaluator: IAuthorizationEvaluator) {
		shared.authorizationEvaluator = evaluator
	}
	
	public static func setAuthenticationEvaluator(_ evaluator: IAuthenticationEvaluator) {
		shared.authenticationEvaluator = evaluator
	}
	
	public static func setLoginEvaluator(_ evaluator: ILoginEvaluator) {
		shared.loginEvaluator = evaluator
	}
}

extension AssemblyContainer {
	public func setAuthorizationInProgress() {
		isAuthorizationInProgress = true
	}
	
	public func setAuthorizationInProgressComplete() {
		isAuthorizationInProgress = false
	}
	
	public func setWorkInProgress() {
		isWorkInProgress = true
	}
	
	public func setWorkInProgressComplete() {
		isWorkInProgress = false
	}
	
	public func resolve(_ transition: ITransition) throws -> UIViewController {
		let result = modules.first { (module: Module, _) -> Bool in
			return module.name == transition.name
		}
		
		guard let assembly = result?.value else {
			throw NSError(domain: "ModuleNotFound", code: 0, userInfo: [:])
		}
		
		canHandleDeeplink = assembly.canHandleDeeplink
	
		if let assemblyLoginName = assemblyForLogin?.module.name, assembly.module.name == assemblyLoginName {
			if let evaluator = loginEvaluator, !evaluator.evaluate() {
				throw ErrorBuilder.build("AlreadyLoggedIn")
			}
		}
		
		if assembly.isAuthenticationRequired,
			let transitionForAuthorization = assemblyForAuthentication?.module.name,
			let evaluator = authenticationEvaluator, evaluator.evaluate() == false {
			returnToTransition = transition
			
			let authorizationTransition = Transition(name: transitionForAuthorization)
			return try resolve(authorizationTransition)
		}
		
		if assembly.isAuthorizationRequired,
			let transitionForAuthorization = assemblyForAuthorization?.module.name,
			let evaluator = authorizationEvaluator, evaluator.evaluate() == false {
			returnToTransition = transition
			
			let parameters: [String: Any] = [
				"deeplink": transition.parameters?["deeplink"] as Any
			]
			let authorizationTransition = Transition(name: transitionForAuthorization, parameters: parameters)
			return try resolve(authorizationTransition)
		}
		
		if assembly.isRegistrationDeeplink,
			let transitionForAuthorization = assemblyForRegistrationDeeplink?.module.name,
			let evaluator = authenticationEvaluator, evaluator.evaluate() == true {
			returnToTransition = transition
			   
			let authorizationTransition = Transition(name: transitionForAuthorization)
			return try resolve(authorizationTransition)
		}
		
		if returnToTransition?.name == transition.name {
			returnToTransition = nil
		}
		
		let controller = try assembly.build(with: transition.parameters)
		return controller
	}
}
