//
//  NetworkService.swift
//  Networking
//
//  Created by NamNH on 02/10/2021.
//

import Foundation
import Alamofire

public class NetworkingService {
	let configurations: INetworkConfigurations
	let httpHeaderHandler: INetworkHTTPHeaderHandler?
	let responseHandler: INetworkHTTPResponseHandler
	let networkConnectionHandler: INetworkConnectionHandler
	
	let manager: Alamofire.Session = {
		let configuration = URLSessionConfiguration.default
		
		return Alamofire.Session(
			configuration: configuration,
			serverTrustManager: ServerTrustManager(allHostsMustBeEvaluated: false,
												   evaluators: ["192.168.1.124": DisabledTrustEvaluator()])
		)
	}()
	
	public init(configurations: INetworkConfigurations,
				httpHeaderHandler: INetworkHTTPHeaderHandler? = nil,
				responseHandler: INetworkHTTPResponseHandler,
				networkConnectionHandler: INetworkConnectionHandler) {
		self.configurations = configurations
		self.httpHeaderHandler = httpHeaderHandler
		self.responseHandler = responseHandler
		self.networkConnectionHandler = networkConnectionHandler
	}
}

// MARK: - INetworkingService
extension NetworkingService: INetworkingService {
	public func request(_ request: URLRequest, type: NetworkRequestType) async throws -> Result<Data?, Error> {
		let result = networkConnectionHandler.waitUntilCheckNetworkConnectionCompleted()
		switch result {
		case .success:
			return try await performFetch(request, type: type)
		case .failure(let error):
			return .failure(error)
		}
	}
	
	public func download(_ request: URLRequest) async throws -> Result<URL?, Error> {
		let result = networkConnectionHandler.waitUntilCheckNetworkConnectionCompleted()
		switch result {
		case .success:
			return try await performDownload(request)
		case .failure(let error):
			return .failure(error)
		}
	}
	
	public func cancelAllRequests() {
		AF.cancelAllRequests()
	}
	
	public func cancel(_ request: URLRequest) {
		AF.session.getTasksWithCompletionHandler { dataTasks, uploadTasks, downloadTaks in
			dataTasks.forEach({
				if $0.originalRequest?.urlRequest == request {
					$0.cancel()
				}
			})
			
			uploadTasks.forEach({
				if $0.originalRequest?.urlRequest == request {
					$0.cancel()
				}
			})
			
			downloadTaks.forEach({
				if $0.originalRequest?.urlRequest == request {
					$0.cancel()
				}
			})
		}
	}
}

// MARK: - Private function
private extension NetworkingService {
	func performFetch(_ request: URLRequest, type: NetworkRequestType) async throws -> Result<Data?, Error> {
		var customRequest = request
		customRequest.cachePolicy = configurations.cachePolicy
		customRequest.allHTTPHeaderFields = httpHeaderHandler?.construct(
			from: request,
			configurations: configurations)
		
		switch type {
		case .data:
			let response = try await withCheckedThrowingContinuation({ continuation in
				self.manager.request(customRequest).responseData { response in
					continuation.resume(returning: response)
				}
			})
			return await responseHandler.handle(response: response)
		case .upload(let multipartForm):
			let response = try await withCheckedThrowingContinuation({ continuation in
				AF.upload(multipartFormData: multipartForm, with: customRequest).responseData { response in
					continuation.resume(returning: response)
				}
			})
			return await responseHandler.handle(response: response)
		}
	}
	
	func performDownload(_ request: URLRequest) async throws -> Result<URL?, Error> {
		var customRequest = request
		customRequest.cachePolicy = configurations.cachePolicy
		customRequest.allHTTPHeaderFields = httpHeaderHandler?.construct(
			from: request,
			configurations: configurations)
		
		let response = try await withCheckedThrowingContinuation({ continuation in
			AF.download(customRequest).responseData { response in
				continuation.resume(returning: response)
			}
		})
		return await responseHandler.handle(response: response)
	}
}
