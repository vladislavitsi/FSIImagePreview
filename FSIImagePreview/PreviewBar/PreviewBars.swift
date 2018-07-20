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
    
    private let statusBarFillingView = UIView()
    private let bottomSafeAreaFiller = UIView()
    let topBar = TopBar()
    let bottomBar = BottomBar()
    var isHidden = true
    
    init(on superview: UIView) {
        statusBarFillingView.translatesAutoresizingMaskIntoConstraints = false
        statusBarFillingView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        bottomSafeAreaFiller.translatesAutoresizingMaskIntoConstraints = false
        bottomSafeAreaFiller.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        topBar.view.translatesAutoresizingMaskIntoConstraints = false
        topBar.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        topBar.actionButtonAction = { [unowned self] in
            self.delegate?.actionButtonPressed()
        }
        topBar.backButtonAction = { [unowned self] in
            self.delegate?.backButtonPressed()
        }
        
        setBars(isHidden: true)
        
        superview.addSubview(statusBarFillingView)
        
        NSLayoutConstraint.activate([
            statusBarFillingView.topAnchor.constraint(equalTo: superview.topAnchor),
            statusBarFillingView.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            statusBarFillingView.trailingAnchor.constraint(equalTo: superview.trailingAnchor)
        ])
        if #available(iOS 11.0, *) {
            statusBarFillingView.bottomAnchor.constraint(equalTo: statusBarFillingView.safeAreaLayoutGuide.topAnchor).isActive = true
        } else {
            statusBarFillingView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        }
            
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
            self?.statusBarFillingView.alpha = isHidden ? 0 : 1
            self?.bottomSafeAreaFiller.alpha = isHidden ? 0 : 1
            self?.topBar.view.alpha = isHidden ? 0 : 1
            self?.bottomBar.view.alpha = isHidden ? 0 : 1
            self?.isHidden = isHidden
            self?.delegate?.setStatusBar(isHidden: isHidden)
        }
        if animated {
            UIView.animate(withDuration: AnimationDuration.short.rawValue, delay: 0, options: .allowUserInteraction, animations: {
                action()
            })
        } else {
            action()
        }
    }

    
    func changeState() {
        setBars(isHidden: !isHidden, animated: true)
    }
}
