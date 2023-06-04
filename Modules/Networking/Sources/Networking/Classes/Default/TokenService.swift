//
//  TokenService.swift
//  Networking
//
//  Created by Max Nguyen on 24/04/2023.
//

import Foundation
import Common
import Dependencies

public struct TokenService {
	let securedStoreService: ISecuredStoreService
}

extension TokenService: ITokenService {
	mutating public func clearToken() {
		self.uid = nil
		self.accessToken = nil
	}
	
	public var uid: String? {
		get {
			return securedStoreService.get(key: "uid") as? String
		}
		set {
			securedStoreService.set(value: newValue, key: "uid")
		}
	}
	
	public var accessToken: String? {
		get {
			return securedStoreService.get(key: "accessToken") as? String
		}
		set {
			securedStoreService.set(value: newValue, key: "accessToken")
		}
	}
}

extension DependencyValues {
	public var tokenService: TokenService {
		get { self[TokenService.self] }
		set { self[TokenService.self] = newValue }
	}
}

extension TokenService: DependencyKey {
	public static var liveValue = Self(securedStoreService: SecuredStoreService())
}
