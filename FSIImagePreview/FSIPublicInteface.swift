//
//  FSIPublicInteface.swift
//  FSIImagePreview
//
//  Created by Uladzislau Kleshchanka on Jul/18/2018.
//  Copyright © 2018 Uladzislau Kleshchanka <vladislavitsi@gmail.com>. All rights reserved.
//

import UIKit

@objc public protocol FSIPublicInteface {
    var topBarView: UIView { get }
    var bottomBarView: UIView { get }
    var currentCounterLabel: UILabel { get }
    var ofCounterLabel: UILabel { get }
    var toCounterLabel: UILabel { get }
    var backButton: UIButton { get }
    var actionButton: UIButton { get }
    func setPreviewBar(isHidden: Bool)
}

