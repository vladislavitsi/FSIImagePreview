//
//  ScrollView.swift
//  FSIImagePreview
//
//  Created by Uladzislau Kleshchanka on Jul/05/2018.
//  Copyright © 2018 Uladzislau Kleshchanka <vladislavitsi@gmail.com>. All rights reserved.
//

import UIKit

class ScrollView: UIScrollView {
    static func getCustomScrollView() -> ScrollView {
        let scrollView = ScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        scrollView.backgroundColor = .clear
        scrollView.alwaysBounceVertical = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.maximumZoomScale = 3.0
        scrollView.minimumZoomScale = 1.0
        return scrollView
    }
}

extension ScrollView {
    
    private static let ZOOM_ANIMATION = 0.4
    
    func zoomWithAnimation() {
        if zoomScale == maximumZoomScale {
            zoomWithAnimation(to: minimumZoomScale)
        } else {
            zoomWithAnimation(to: maximumZoomScale)
        }
    }
    
    private func zoomWithAnimation(to scale: CGFloat) {
        UIView.animate(withDuration: ScrollView.ZOOM_ANIMATION) { [unowned self] in
            self.zoomScale = scale
        }
    }
}

