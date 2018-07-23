//
//  PreviewBarProtocol.swift
//  FSIImagePreview
//
//  Created by Uladzislau Kleshchanka on Jul/16/2018.
//  Copyright © 2018 Uladzislau Kleshchanka <vladislavitsi@gmail.com>. All rights reserved.
//

import UIKit

protocol PreviewBarDelegate: class {
    func backButtonPressed()
    func actionButtonPressed()
    func setStatusBar(isHidden: Bool)
    func sizeClassIsCompact() -> Bool
}
