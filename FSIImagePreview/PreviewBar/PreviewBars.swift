//
//  PreviewBar.swift
//  FSIImagePreview
//
//  Created by Uladzislau Kleshchanka on Jul/06/2018.
//  Copyright © 2018 Uladzislau Kleshchanka <vladislavitsi@gmail.com>. All rights reserved.
//

import UIKit


class PreviewBars {
    
    weak var delegate: PreviewBarDelegate?
    
    let statusBarFillingView = UIView()
    private let bottomSafeAreaFiller = UIView()
    let topBar = TopBar()
    let bottomBar = BottomBar()
    var isHidden = true
    private let statusBarHeight = DeviceSupport.getStatusBarHeight()
    private var topScreenConstraint: NSLayoutConstraint
    
    init(on superview: UIView) {
        statusBarFillingView.translatesAutoresizingMaskIntoConstraints = false
        statusBarFillingView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        bottomSafeAreaFiller.translatesAutoresizingMaskIntoConstraints = false
        bottomSafeAreaFiller.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        topBar.view.translatesAutoresizingMaskIntoConstraints = false
        topBar.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        topScreenConstraint = statusBarFillingView.heightAnchor.constraint(equalToConstant: statusBarHeight)
        
        superview.addSubview(statusBarFillingView)
        NSLayoutConstraint.activate([
            statusBarFillingView.topAnchor.constraint(equalTo: superview.topAnchor),
            statusBarFillingView.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            statusBarFillingView.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            topScreenConstraint
        ])
        
        topBar.actionButtonAction = { [unowned self] in
            self.delegate?.actionButtonPressed()
        }
        topBar.backButtonAction = { [unowned self] in
            self.delegate?.backButtonPressed()
        }
        
        setBars(isHidden: true)

        superview.addSubview(bottomSafeAreaFiller)
        var superViewBottomAnchor: NSLayoutYAxisAnchor!
        if #available(iOS 11.0, *) {
            superViewBottomAnchor = superview.safeAreaLayoutGuide.bottomAnchor
        } else {
            superViewBottomAnchor = superview.bottomAnchor
        }
        NSLayoutConstraint.activate([
            bottomSafeAreaFiller.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            bottomSafeAreaFiller.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            bottomSafeAreaFiller.bottomAnchor.constraint(equalTo: superview.bottomAnchor),
            bottomSafeAreaFiller.topAnchor.constraint(equalTo: superViewBottomAnchor)
        ])
        
        superview.addSubview(topBar.view)
        NSLayoutConstraint.activate([
            topBar.view.topAnchor.constraint(equalTo: statusBarFillingView.bottomAnchor),
            topBar.view.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            topBar.view.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            topBar.view.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        superview.addSubview(bottomBar.view)
        NSLayoutConstraint.activate([
            bottomBar.view.bottomAnchor.constraint(equalTo: bottomSafeAreaFiller.topAnchor),
            bottomBar.view.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            bottomBar.view.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            bottomBar.view.heightAnchor.constraint(equalToConstant: 44)
        ])
        
    }
    
    func setBars(isHidden: Bool, animated: Bool = false) {
        let action = { [weak self] in
            self?.bottomSafeAreaFiller.alpha = isHidden ? 0 : 1
            self?.topBar.view.alpha = isHidden ? 0 : 1
            self?.setStatusBar(isHidden: isHidden)
            self?.statusBarFillingView.alpha = isHidden ? 0 : 1
            self?.bottomBar.view.alpha = isHidden ? 0 : 1
            self?.isHidden = isHidden
        }
        if animated {
            UIView.animate(withDuration: AnimationDuration.short.rawValue, delay: 0, options: .allowUserInteraction, animations: {
                action()
            })
        } else {
            action()
        }
    }
    
    func setStatusBar(isHidden: Bool) {
        if delegate?.sizeClassIsCompact() ?? false {
            topScreenConstraint.constant = 0
            delegate?.setStatusBar(isHidden: true)
        } else {
            topScreenConstraint.constant = statusBarHeight
            statusBarFillingView.alpha = isHidden ? 0 : 1
            delegate?.setStatusBar(isHidden: isHidden)
        }
    }
    
    func updateStatusBar() {
        setStatusBar(isHidden: isHidden)
    }
 
    func changeState() {
        setBars(isHidden: !isHidden, animated: true)
    }
}
