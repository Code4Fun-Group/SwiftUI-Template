//
//  SystemInfo.swift
//  Common
//
//  Created by Nguyễn Nam on 4/8/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit

public enum DeviceType {
	case iPhoneSE
	case iPhone678
	case iPhone678Plus
	case iPhone11Pro
	case iPhone11ProMax
	case iPhone12Pro
	case iPhone12ProMax
	
	fileprivate init?(_ rawValue: CGFloat?) {
		switch rawValue {
		case 568.0:
			self = .iPhoneSE
		case 667.0:
			self = .iPhone678
		case 736.0:
			self = .iPhone678Plus
		case 812.0:
			self = .iPhone11Pro
		case 896.0:
			self = .iPhone11ProMax
		case 844.0:
			self = .iPhone12Pro
		case 926.0:
			self = .iPhone12ProMax
		default:
			return nil
		}
	}
}

public class SystemInfo {
	// MARK: - ScreenInfo
	public static let screenBounds 		= UIScreen.main.bounds
	public static let screenWidth 			= UIScreen.main.bounds.width
	public static let screenHeight 		= UIScreen.main.bounds.height
	public static let screenNativeBounds 	= UIScreen.main.nativeBounds
	public static let screenNativeWidth	= UIScreen.main.nativeBounds.width
	public static let screenNativeHeight 	= UIScreen.main.nativeBounds.height
	public static var statusBarHeight: CGFloat {
		guard let window = UIApplication.shared.windows.first else { return 0 }
		return window.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
	}
	public static var safeAreaInsetTop: CGFloat {
		guard let window = UIApplication.shared.windows.first else { return 0 }
		return window.safeAreaInsets.top
	}
	public static var safeAreaInsetBottom: CGFloat {
		guard let window = UIApplication.shared.windows.first else { return 0 }
		return window.safeAreaInsets.bottom
	}
	
	// MARK: - Device
	public static var deviceType: DeviceType? {
		return DeviceType(screenHeight)
	}
}
