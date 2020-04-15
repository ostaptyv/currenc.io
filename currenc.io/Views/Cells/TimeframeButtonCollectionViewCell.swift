//
//  TimeframeButtonCollectionViewCell.swift
//  currenc.io
//
//  Created by Ostap on 10.04.2020.
//  Copyright © 2020 Ostap Tyvonovych. All rights reserved.
//

import UIKit

class TimeframeButtonCollectionViewCell: UICollectionViewCell, Setuppable {
    
    private var selectedShapeView: UIView!
    private var timeframeLabel: UILabel!
    
    private var commonConstraints = [NSLayoutConstraint]()
    
    var titleText: String? {
        get {
            return timeframeLabel.text
        }
        set {
            timeframeLabel.text = newValue
        }
    }
    
    override var isSelected: Bool {
        willSet {
            layoutButton(isSelected: newValue)
        }
    }
    
    private var isInterfaceInitialized = false
    
    // MARK: - Setup interface
    
    func setupInstance() {
        if !isInterfaceInitialized {
            setupInterface()
        }
    }
    
    // MARK: - Setup interface
    
    private func setupInterface() {
        initializeInterface()
        setupViewHierarchy()
        constraintInterface()
        layoutButton(isSelected: self.isSelected)
    }
    
    // MARK: - Initalize UI
    
    private func initializeInterface() {
        selectedShapeView = makeSelectedShapeView()
        timeframeLabel = makeTimeframeLabel()
        
        isInterfaceInitialized = true
    }
    
    private func makeSelectedShapeView() -> UIView {
        let selectedShapeView = UIView()
        selectedShapeView.layer.cornerRadius = .selectedShapeViewCornerRadius
        
        return selectedShapeView
    }
    
    private func makeTimeframeLabel() -> UILabel {
        let timeframeLabel = UILabel()
        timeframeLabel.font = .timeframeLabelFont
        
        return timeframeLabel
    }
    
    // MARK: - Make up view hierarchy
    
    private func setupViewHierarchy() {
        self.contentView.addSubview(selectedShapeView)
        selectedShapeView.addSubview(timeframeLabel)
    }
    
    // MARK: - Setup constraints
    
    private func constraintInterface() {
        constraintSelectedShapeView(selectedShapeView)
        constraintTimeframeLabel(timeframeLabel)
        
        NSLayoutConstraint.activate(commonConstraints)
    }
    
    private func constraintSelectedShapeView(_ selectedShapeView: UIView) {
        selectedShapeView.translatesAutoresizingMaskIntoConstraints = false
        
        commonConstraints.append(contentsOf: [
            selectedShapeView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: .selectedShapeViewCenterXAnchorValue),
            selectedShapeView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: .selectedShapeViewCenterYAnchorValue),
            selectedShapeView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .selectedShapeViewLeadingAnchorValue)
        ])
    }
    
    private func constraintTimeframeLabel(_ timeframeLabel: UIView) {
        timeframeLabel.translatesAutoresizingMaskIntoConstraints = false
    
        commonConstraints.append(contentsOf: [
            timeframeLabel.centerYAnchor.constraint(equalTo: selectedShapeView.centerYAnchor, constant: .timeframeLabelCenterYAnchorValue),
            timeframeLabel.firstBaselineAnchor.constraint(equalTo: selectedShapeView.bottomAnchor, constant: .timeframeLabelFirstBaselineAnchorValue),
            timeframeLabel.centerXAnchor.constraint(equalTo: selectedShapeView.centerXAnchor, constant: .timeframeLabelCenterXAnchorValue),
            timeframeLabel.leadingAnchor.constraint(equalTo: selectedShapeView.leadingAnchor, constant: .timeframeLabelLeadingAnchorValue)
        ])
    }
    
    // MARK: - Layout button if selected
    
    private func layoutButton(isSelected: Bool) {
        let labelTextColor: UIColor
        let shapeColor: UIColor
        
        if isSelected {
            labelTextColor = .labelTextColorSelected
            shapeColor = .shapeColorSelected
        } else {
            labelTextColor = .labelTextColorUnselected
            shapeColor = .shapeColorUnselected
        }
        
        timeframeLabel?.textColor = labelTextColor
        selectedShapeView?.backgroundColor = shapeColor
    }
}

// MARK: - Constants

fileprivate extension CGFloat {
    // MARK: Font sizes
    static let timeframeLabelFontSize: CGFloat = 13.0
    
    // MARK: Selected shape view constants
    static let selectedShapeViewCornerRadius: CGFloat = 12.0
    
    // MARK: Constraint values
    static let selectedShapeViewCenterXAnchorValue: CGFloat = 0.0
    static let selectedShapeViewCenterYAnchorValue: CGFloat = 0.0
    static let selectedShapeViewLeadingAnchorValue: CGFloat = 10.0
    
    static let timeframeLabelCenterYAnchorValue: CGFloat = 0.0
    static let timeframeLabelFirstBaselineAnchorValue: CGFloat = -8.0
    static let timeframeLabelCenterXAnchorValue: CGFloat = 0.0
    static let timeframeLabelLeadingAnchorValue: CGFloat = 10.0
}

fileprivate extension UIColor {
    static let labelTextColorSelected = UIColor.white
    static let shapeColorSelected = UIColor(hex: "434650")!
    
    static let labelTextColorUnselected = UIColor(hex: "22252A")!
    static let shapeColorUnselected = UIColor.clear
}

fileprivate extension UIFont {
    static let timeframeLabelFont = UIFont.systemFont(ofSize: .timeframeLabelFontSize, weight: .semibold)
}
