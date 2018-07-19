//
//  ImageViewExtension.swift
//  FSIImagePreview
//
//  Created by Uladzislau Kleshchanka on Jul/05/2018.
//  Copyright © 2018 Uladzislau Kleshchanka <vladislavitsi@gmail.com>. All rights reserved.
//

import UIKit

extension UIImageView {
    static func getCustomImageView(for image: UIImage, initialFrame: CGRect?) -> UIImageView {
        let imageView = UIImageView(frame: initialFrame ?? CGRect.zero)
        imageView.isUserInteractionEnabled = true
        imageView.isMultipleTouchEnabled = true
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        return imageView
    }
}

extension UIView {
    var globalFrame :CGRect? {
        return self.superview?.convert(self.frame, to: nil)
    }
}
