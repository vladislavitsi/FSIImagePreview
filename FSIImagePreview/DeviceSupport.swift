//
//  DeviceSupport.swift
//  FSIImagePreview
//
//  Created by Uladzislau Kleshchanka on Jul/23/2018.
//  Copyright © 2018 Uladzislau Kleshchanka <vladislavitsi@gmail.com>. All rights reserved.
//

import UIKit

class DeviceSupport {
    private static let SCREEN_HEIGHT_IPHONE_X = CGFloat(812)
    
    static let DEFAULT_STATUS_BAR_HEIGHT = CGFloat(20)
    static let IPHONE_X_STATUS_BAR_HEIGHT = CGFloat(44)
    
    static func isIphoneX() -> Bool {
        return max(UIScreen.main.bounds.size.height, UIScreen.main.bounds.size.width) == SCREEN_HEIGHT_IPHONE_X
    }
    
    static func getStatusBarHeight() -> CGFloat {
        return isIphoneX() ? IPHONE_X_STATUS_BAR_HEIGHT : DEFAULT_STATUS_BAR_HEIGHT
    }
}
