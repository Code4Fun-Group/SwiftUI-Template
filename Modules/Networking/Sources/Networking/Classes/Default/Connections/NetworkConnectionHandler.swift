//
//  NetworkConnectionHandler.swift
//  Networking
//
//  Created by NamNH on 02/10/2021.
//

import Foundation

public class NetworkConnectionHandler: INetworkConnectionHandler {
	public init() {}
	
	public func waitUntilCheckNetworkConnectionCompleted() -> Result<Bool, Error> {
		isNetworkAvailable() ? .success(true): .failure(NetworkConnectionError.unavailable)
	}
}

// MARK: - Private function
private extension NetworkConnectionHandler {
	func isNetworkAvailable() -> Bool {
		let reachability = try? Reachability()
		
		switch reachability?.connection {
		case .cellular, .wifi:
			return true
		case .unavailable:
			return false
		case .none?:
			return false
		case nil:
			return false
		}
	}
}
