//
//  FSIPublicInteface.swift
//  FSIImagePreview
//
//  Created by Uladzislau Kleshchanka on Jul/18/2018.
//  Copyright © 2018 Uladzislau Kleshchanka <vladislavitsi@gmail.com>. All rights reserved.
//

import UIKit

/// Public inteface protocol that let you to customise your FSIViewController. For example, hide bottom bar or action button,
/// change back button icon, implement custom bar background.
@objc public protocol FSIPublicInteface {
    /// The top bar backround view.
    var topBarView: UIView { get }
    
    /// The bottom bar background view.
    var bottomBarView: UIView { get }
    
    /// The label that shows current page number.
    var currentCounterLabel: UILabel { get }
    
    /// The label-divider, between two number counters. By default the text is 'Of'.
    var ofCounterLabel: UILabel { get }
    
    /// The label that shows current page number.
    var totalNumberLabel: UILabel { get }
    
    /// The button on top bar. Closing image preview.
    var backButton: UIButton { get }
    
    /// The action on top bar. Opens action sheet, if implemented.
    var actionButton: UIButton { get }
    
    /// Makes all preview bars are hidden and vice versa.
    ///
    /// - parameter isHidden: If True, preview bars will be hidden.
    func setPreviewBar(isHidden: Bool)
    
    /// Present the FSIViewController on given UIViewController
    ///
    /// - parameter viewController: UIViewController, on wich FSIViewController will be presented.
    func show(on viewController: UIViewController)
}

