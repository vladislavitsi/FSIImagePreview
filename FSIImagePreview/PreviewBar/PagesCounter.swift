//
//  PagesCouner.swift
//  FSIImagePreview
//
//  Created by Uladzislau Kleshchanka on Jul/11/2018.
//  Copyright © 2018 Uladzislau Kleshchanka <vladislavitsi@gmail.com>. All rights reserved.
//

import UIKit

public class PageCounter {
    
    private static let defaultFont = UIFont(name: "Helvetica Neue", size: 20)!
    
    let view = UIStackView()
    let currentLabel = UILabel()
    let ofLabel = UILabel()
    let totalNumberLabel = UILabel()
    
    init() {
        view.spacing = 7
        view.axis = .horizontal
        view.alignment = .fill
        view.distribution = .fillEqually
        view.translatesAutoresizingMaskIntoConstraints = false
        
        currentLabel.text = "1"
        currentLabel.textAlignment = .right
        ofLabel.text = "Of"
        ofLabel.textAlignment = .center
        totalNumberLabel.text = "1"
        totalNumberLabel.textAlignment = .left
        
        let labels = [currentLabel, ofLabel, totalNumberLabel]
        labels.forEach { label in
            label.font = PageCounter.defaultFont
            label.textColor = .white
            view.addArrangedSubview(label)
        }
    }
    
    func setCurrent(number: Int) {
        currentLabel.text = String(number)
    }
    
    func setAll(number: Int) {
        totalNumberLabel.text = String(number)
    }
}
