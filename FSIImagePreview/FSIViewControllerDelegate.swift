//
//  FSIViewControllerDelegate.swift
//  FSIImagePreview
//
//  Created by Uladzislau Kleshchanka on Jul/17/2018.
//  Copyright © 2018 Uladzislau Kleshchanka <vladislavitsi@gmail.com>. All rights reserved.
//

import UIKit

/// Delegate protocol, conform to it to handle FSIViewController's generated events.
@objc public protocol FSIViewControllerDelegate: class {
    /// Called on tap
    func didTap()
    
    /// Called on double tap
    func didDoubleTap()
    
    /// Called on swipe back, before the viewController will be dissessed
    func didSwipeBack()
    
    /// Called on page changing
    func didChangePage()
}
