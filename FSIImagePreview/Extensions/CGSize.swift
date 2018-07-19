//
//  CGSize.swift
//  FSIImagePreview
//
//  Created by Uladzislau Kleshchanka on Jul/06/2018.
//  Copyright © 2018 Uladzislau Kleshchanka <vladislavitsi@gmail.com>. All rights reserved.
//

import UIKit

extension CGSize {
    func ratio() -> CGFloat {
        return width / height
    }
}
