//
//  CurrencyInfoTableViewCell.swift
//  currenc.io
//
//  Created by Ostap on 12.04.2020.
//  Copyright © 2020 Ostap Tyvonovych. All rights reserved.
//

import UIKit

class CurrencyInfoTableViewCell: UITableViewCell, Setuppable {

    var titleLabel: UILabel!
    var valueLabel: UILabel!
    
    private var commonConstraints = [NSLayoutConstraint]()
    
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
    }
    
    // MARK: - Initalize UI
    
    private func initializeInterface() {
        titleLabel = makeTitleLabel()
        valueLabel = makeValueLabel()
        
        isInterfaceInitialized = true
    }
    
    private func makeTitleLabel() -> UILabel {
        let titleLabel = UILabel()
        return titleLabel
    }
    
    private func makeValueLabel() -> UILabel {
        let valueLabel = UILabel()
        return valueLabel
    }
    
    // MARK: - Make up view hierarchy
    
    private func setupViewHierarchy() {
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(valueLabel)
    }
    
    // MARK: - Setup constraints
    
    private func constraintInterface() {
        constraintTitleLabel(titleLabel)
        constraintValueLabel(valueLabel)
        
        NSLayoutConstraint.activate(commonConstraints)
    }
    
    private func constraintTitleLabel(_ titleLabel: UIView) {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        commonConstraints.append(contentsOf: [
            titleLabel.firstBaselineAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: .titleLabelFirstBaselineAnchorValue),
            titleLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor, constant: .titleLabelCenterYAnchorValue),
            titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: .titleLabelLeadingAnchorValue)
        ])
    }
    
    private func constraintValueLabel(_ valueLabel: UIView) {
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        commonConstraints.append(contentsOf: [
            valueLabel.firstBaselineAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: .valueLabelFirstBaselineAnchorValue),
            valueLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor, constant: .valueLabelCenterYAnchorValue),
            valueLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: .valueLabelTrailingAnchorValue)
        ])
    }
}

// MARK: - Constants

fileprivate extension CGFloat {
    // MARK: Constraint values
    static let titleLabelFirstBaselineAnchorValue: CGFloat = -20.0
    static let titleLabelCenterYAnchorValue: CGFloat = 0.0
    static let titleLabelLeadingAnchorValue: CGFloat = 16.0
    
    static let valueLabelFirstBaselineAnchorValue: CGFloat = -20.0
    static let valueLabelCenterYAnchorValue: CGFloat = 0.0
    static let valueLabelTrailingAnchorValue: CGFloat = -16.0
}
