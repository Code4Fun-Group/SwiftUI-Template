//
//  NetworkHTTPHeaderHandler.swift
//  Networking
//
//  Created by NamNH on 02/10/2021.
//

import Foundation
import Dependencies

public struct NetworkHTTPHeaderHandler {
	@Dependency(\.tokenService) var tokenService
	
	public init() {}
}

extension NetworkHTTPHeaderHandler: INetworkHTTPHeaderHandler {
	public func construct(from request: URLRequest, configurations: INetworkConfigurations) -> [String: String]? {
		var customFields = request.allHTTPHeaderFields ?? [:]
		
		if let accessToken = tokenService.accessToken {
			customFields["Authorization"] = "Bearer " + accessToken
		}
		
		let headerFields = configurations.defaultHTTPHeaderFields.merging(customFields) { (_, new) -> String in
			return new
		}
		
		return headerFields
	}
}
