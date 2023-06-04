//
//  NetworkHTTPResponseHandler.swift
//  Networking
//
//  Created by NamNH on 02/10/2021.
//

import Foundation
import Alamofire

public struct NetworkHTTPResponseHandler {
	public init() { }
}

// MARK: - INetworkHTTPResponseHandler
extension NetworkHTTPResponseHandler: INetworkHTTPResponseHandler {
	public func handle(response: Alamofire.AFDataResponse<Data>) async -> Result<Data?, Error> {
		guard let httpResponse = response.response else {
			if let errorResponse = response.error as NSError? {
				if errorResponse.code == NSURLErrorTimedOut {
					return .failure(NetworkConnectionError.timeOut)
				}
				return .failure(errorResponse)
			}
			return .failure(NetworkConnectionError.unavailable)
		}
		
		switch httpResponse.statusCode {
		case 200..<399:
			return .success(response.data)
			
		default:
			let responseError = NetworkResponseErrorBuilder.build(
				data: response.data,
				response: httpResponse,
				error: response.error)
			
			return .failure(responseError)
		}
	}
	
	public func handle(response: Alamofire.AFDownloadResponse<Data>) async -> Result<URL?, Error> {
		guard let httpResponse = response.response else {
			if let errorResponse = response.error as NSError? {
				if errorResponse.code == NSURLErrorTimedOut {
					return .failure(NetworkConnectionError.timeOut)
				}
				return .failure(errorResponse)
			}
			return .failure(NetworkConnectionError.unavailable)
		}
		
		switch httpResponse.statusCode {
		case 200..<399:
			return .success(response.fileURL)
			
		default:
			let responseError = NetworkResponseErrorBuilder.build(
				data: nil,
				response: httpResponse,
				error: response.error)
			
			return .failure(responseError)
		}
	}
}
