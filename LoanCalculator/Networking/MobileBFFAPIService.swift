//
//  MobileBFFAPIService.swift
//  MySampleUI
//
//  Created by Max Nguyen on 24/04/2023.
//

import Foundation
import Dependencies
import Networking
import Alamofire

struct MobileBFFAPIService {
	@Dependency(\.tokenService) var tokenService
	var client: NetworkingService
	
	func fetch(request: MobileBFFAPIService.Request) async throws -> Result<Data?, Error> {
		let url = ConfigurationProvider.default.mobileBFFEndpoint.appendingPathComponent(request.path)
		var components = URLComponents(string: url.absoluteString)
		if let queryItems = request.queryItems {
			components?.queryItems = queryItems
		}
		
		var requestURL = URLRequest(url: components?.url ?? url)
		requestURL.httpMethod = request.method.rawValue
		if let parameters = request.paramters {
			let data = try? JSONSerialization.data(withJSONObject: parameters as Any, options: [.prettyPrinted])
			requestURL.httpBody = data
		}
		
		return try await client.request(requestURL, type: .data)
	}
}

extension MobileBFFAPIService {
	enum Request {
		case getSomeThings
		case postSomethings(parameters: Parameters)
		
		var path: String {
			switch self {
			case .getSomeThings:
				return "breeds/image/random"
			case .postSomethings:
				return ""
			}
		}
		
		var method: HTTPMethod {
			switch self {
			case .getSomeThings:
				return .get
			case .postSomethings:
				return .post
			}
		}
		
		var queryItems: [URLQueryItem]? {
			switch self {
			default: return nil
			}
		}
		
		var paramters: Parameters? {
			switch self {
			case let .postSomethings(paramters):
				return paramters
			default: return nil
			}
		}
	}
	
}

extension DependencyValues {
	var mobileBFFAPIService: MobileBFFAPIService {
		get { self[MobileBFFAPIService.self] }
		set { self[MobileBFFAPIService.self] = newValue }
	}
}

extension MobileBFFAPIService: DependencyKey {
	static let liveValue = Self(
		client: NetworkingService(configurations: NetworkConfigurations(),
								  httpHeaderHandler: NetworkHTTPHeaderHandler(),
								  responseHandler: NetworkHTTPResponseHandler(),
								  networkConnectionHandler: NetworkConnectionHandler())
	)
}
