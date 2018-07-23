//
//  TopBar.swift
//  FSIImagePreview
//
//  Created by Uladzislau Kleshchanka on Jul/09/2018.
//  Copyright © 2018 Uladzislau Kleshchanka <vladislavitsi@gmail.com>. All rights reserved.
//

import UIKit

class TopBar: AbstractBar {
    
    let backButton = UIButton()
    let pageCounter = PageCounter()
    let actionButton = UIButton()
    
    var actionButtonAction: ((_ : UIButton) -> Void)?
    var backButtonAction: (() -> Void)?
    
    override init() {
        super.init()
        backButton.setImage(UIImage(named: "Back arrow", in: Bundle(for: type(of: self)), compatibleWith: nil), for: .normal)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backButton)
        
        var viewLeadingAnchor: NSLayoutXAxisAnchor!
        if #available(iOS 11.0, *) {
            viewLeadingAnchor = view.safeAreaLayoutGuide.leadingAnchor
        } else {
            viewLeadingAnchor = view.leadingAnchor
        }
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: viewLeadingAnchor, constant: 7),
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 5),
            backButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -5),
            backButton.widthAnchor.constraint(equalTo: backButton.heightAnchor, multiplier: 1)
        ])
        
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        
        view.addSubview(pageCounter.view)
        NSLayoutConstraint.activate([
            pageCounter.view.topAnchor.constraint(equalTo: view.topAnchor),
            pageCounter.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            pageCounter.view.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        
        actionButton.setImage(UIImage(named: "Meatballs menu", in: Bundle(for: type(of: self)), compatibleWith: nil), for: .normal)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(actionButton)

        var viewTrailingAnchor: NSLayoutXAxisAnchor!
        if #available(iOS 11.0, *) {
            viewTrailingAnchor = view.safeAreaLayoutGuide.trailingAnchor
        } else {
            viewTrailingAnchor = view.trailingAnchor
        }
        NSLayoutConstraint.activate([
            actionButton.trailingAnchor.constraint(equalTo: viewTrailingAnchor, constant: -7),
            actionButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 5),
            actionButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -5),
            actionButton.widthAnchor.constraint(equalTo: actionButton.heightAnchor, multiplier: 1)
        ])
        actionButton.addTarget(self, action: #selector(actionButtonPressed(_:)), for: .touchUpInside)
    }
    
    @objc func actionButtonPressed(_ sender: UIButton) {
        actionButtonAction?(sender)
    }
    
    @objc func backButtonPressed() {
        backButtonAction?()
    }
    
}


