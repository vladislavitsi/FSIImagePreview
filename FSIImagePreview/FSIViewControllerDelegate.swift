//
//  FSIViewControllerDelegate.swift
//  FSIImagePreview
//
//  Created by Uladzislau Kleshchanka on Jul/17/2018.
//  Copyright © 2018 Uladzislau Kleshchanka <vladislavitsi@gmail.com>. All rights reserved.
//

import UIKit

@objc public protocol FSIViewControllerDelegate: class {
    func didTap()
    func didDoubleTap()
    func didSwipeBack()
    func didChangePage()
}
