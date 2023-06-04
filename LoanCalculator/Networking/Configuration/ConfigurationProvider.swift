//
//  ConfigurationProvider.swift
//  MySampleUI
//
//  Created by Max Nguyen on 23/04/2023.
//

// swiftlint: disable force_unwrapping
import Foundation

protocol IConfigurationProvider {
	var mobileBFFAPIKey: String { get }
	var mobileBFFEndpoint: URL { get }
}

enum ConfigurationProvider: IConfigurationProvider {
	case `default`
	
	enum Keys {
		static let mobileBFFAPIKey = "MOBILE_BFF_API_KEY"
	}
	
	enum Paths {
		static let mobileBFFEndpoint = "MOBILE_BFF_ENDPOINT"
	}
	
	var mobileBFFAPIKey: String {
		Configuration.value(for: Keys.mobileBFFAPIKey)
	}
	
	var mobileBFFEndpoint: URL {
		URL(string: Configuration.value(for: Paths.mobileBFFEndpoint))!
	}
}
