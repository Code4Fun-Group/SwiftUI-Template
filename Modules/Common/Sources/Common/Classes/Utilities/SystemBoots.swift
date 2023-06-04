//
//  SystemBoots.swift
//  Common
//
//  Created by NamNH on 02/10/2021.
//

import UIKit

public class SystemBoots {
	public class func changeRoot(window: inout UIWindow?, rootController: UIViewController) {
		// Setup app's window
		guard window == nil else {
			window?.rootViewController = rootController
			window?.makeKeyAndVisible()
			return
		}
		window = UIWindow(frame: SystemInfo.screenBounds)
		window?.backgroundColor = .clear
		window?.rootViewController = rootController
		window?.makeKeyAndVisible()
	}
}
