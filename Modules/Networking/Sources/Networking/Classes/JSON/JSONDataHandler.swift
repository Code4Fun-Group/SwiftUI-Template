//
//  JSONDataHandler.swift
//  Networking
//
//  Created by NamNH on 30/09/2021.
//

import Foundation

public enum JSONDataHandlerError: Error {
	case emptyResponse
	case serialization(responseError: Error)
}

public struct JSONDataHandler: INetworkingServiceDataHandler {
	public init() {}
	
	public func handle<T: Decodable>(jsonData: Data?) async -> Result<T, Error> {
		guard let data = jsonData else {
			return .failure(JSONDataHandlerError.emptyResponse)
		}
		
		do {
			let decoder = JSONDecoder()
			let result = try decoder.decode(T.self, from: data)
			return .success(result)
			
		} catch {
			return .failure(JSONDataHandlerError.serialization(responseError: error))
		}
	}
}
