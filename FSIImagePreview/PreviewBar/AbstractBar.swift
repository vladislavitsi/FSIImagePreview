//
//  AbstractBar.swift
//  FSIImagePreview
//
//  Created by Uladzislau Kleshchanka on Jul/18/2018.
//  Copyright © 2018 Uladzislau Kleshchanka <vladislavitsi@gmail.com>. All rights reserved.
//

import UIKit

class AbstractBar {
    let view = UIView()
    
    init() {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    }
}
