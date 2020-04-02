//
//  CurrencyRateViewController.swift
//  currenc.io
//
//  Created by Ostap on 02.04.2020.
//  Copyright © 2020 Ostap Tyvonovych. All rights reserved.
//

import UIKit

class CurrencyRateViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var contentView: UIView!
    private var collectionView: UICollectionView!
    private var pageControl: UIPageControl!
    private var pageControlBarButton: UIBarButtonItem!
    private var addCurrencyBarButton: UIBarButtonItem!

    private var commonConstraints = [NSLayoutConstraint]()
    
    // MARK: - View controller lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInterface()
    }
    
    // MARK: - Setup interface
    
    private func setupInterface() {
        self.view.backgroundColor = .mainViewBackgroungColorDynamic

        initializeInterface()
        setupViewHierarchy()
        constraintInterface()
    }
    
    // MARK: - Initalize UI
    
    private func initializeInterface() {
        contentView = makeContentView()
        collectionView = makeCollectionView()
        pageControl = makePageControl()
        pageControlBarButton = makePageControlBarButton(using: pageControl)
        addCurrencyBarButton = makeAddCurrencyBarButton()
    }
    
    private func makeContentView() -> UIView {
        let contentView = UIView()
        contentView.backgroundColor = .contentViewBackgroundColor
        
        return contentView
    }
    
    private func makeCollectionView() -> UICollectionView {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = .collectionViewMinimumLineSpacing
        flowLayout.sectionInset = UIEdgeInsets(top: .collectionViewFlowLayoutSectionInsetTopValue, left: .collectionViewFlowLayoutSectionInsetLeftValue, bottom: .collectionViewFlowLayoutSectionInsetBottomValue, right: .collectionViewFlowLayoutSectionInsetRightValue)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .collectionViewBackgroundColor
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: .collectionViewCellReuseIdentifier)
        
        return collectionView
    }
    
    private func makePageControl() -> UIPageControl {
        let pageControl = UIPageControl()
        pageControl.pageIndicatorTintColor = .pageControlIndicatorTintColorDynamic
        pageControl.currentPageIndicatorTintColor = .pageControlCurrentIndicatorTintColorDynamic
        pageControl.numberOfPages = 5 // temporary
        pageControl.sizeToFit()
        
        return pageControl
    }
    
    private func makePageControlBarButton(using pageControl: UIPageControl) -> UIBarButtonItem {
        pageControl.sizeToFit()
        return UIBarButtonItem(customView: pageControl)
    }
        
    private func makeAddCurrencyBarButton() -> UIBarButtonItem {
        let addCurrencyBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addCurrencyBarButtonTapped(_:)))
        
        return addCurrencyBarButton
    }
    
    // MARK: - Make up view hierarchy
    
    private func setupViewHierarchy() {
        self.view.addSubview(contentView)
        contentView.addSubview(collectionView)
        
        setupToolbar(using: self.navigationController)
    }
    
    private func setupToolbar(using navigationController: UINavigationController?) {
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        self.toolbarItems = [flexibleSpace, pageControlBarButton, flexibleSpace, addCurrencyBarButton]
        
        navigationController?.isToolbarHidden = false
        navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: - Setup constraints
    
    private func constraintInterface() {
        constraintContentView(contentView)
        constraintCollectionView(collectionView)
        
        NSLayoutConstraint.activate(commonConstraints)
    }
    
    private func constraintContentView(_ contentView: UIView) {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        let safeAreaLayoutGuide = self.view.safeAreaLayoutGuide
        commonConstraints.append(contentsOf: [
            contentView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: .contentViewTopAnchorValue),
            contentView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: .contentViewBottomAnchorValue),
            contentView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: .contentViewLeadingAnchorValue),
            contentView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: .contentViewTrailingAnchorValue)
        ])
    }
    
    private func constraintCollectionView(_ collectionView: UIView) {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        commonConstraints.append(contentsOf: [
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .collectionViewTopAnchorValue),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: .collectionViewBottomAnchorValue),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .collectionViewLeadingAnchorValue),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: .collectionViewTrailingAnchorValue)
        ])
    }
    
    // MARK: - Corresponding to button taps
    
    @objc private func addCurrencyBarButtonTapped(_ sender: UIBarButtonItem) {
        
    }
    
    // MARK: - Collection view data source methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5 // temporary
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: .collectionViewCellReuseIdentifier, for: indexPath)
        cell.backgroundColor = .green //
        
        return cell
    }
    
    // MARK: - Collection view delegate methods (flow layout)
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.bounds.size.width, height: collectionView.bounds.size.height)
    }
}


// MARK: - Constants
fileprivate extension CGFloat {
    static let collectionViewMinimumLineSpacing: CGFloat = 20.0
    
    // MARK: Collection view cell section insets values
    static let collectionViewFlowLayoutSectionInsetTopValue: CGFloat = 0.0
    static let collectionViewFlowLayoutSectionInsetBottomValue: CGFloat = 0.0
    static let collectionViewFlowLayoutSectionInsetLeftValue: CGFloat = .collectionViewMinimumLineSpacing / 2
    static let collectionViewFlowLayoutSectionInsetRightValue: CGFloat = .collectionViewMinimumLineSpacing / 2
    
    // MARK: Constraint values
    static let contentViewTopAnchorValue: CGFloat = 0.0
    static let contentViewBottomAnchorValue: CGFloat = 0.0
    static let contentViewLeadingAnchorValue: CGFloat = 0.0
    static let contentViewTrailingAnchorValue: CGFloat = 0.0
    
    static let collectionViewTopAnchorValue: CGFloat = 0.0
    static let collectionViewBottomAnchorValue: CGFloat = 0.0
    static let collectionViewLeadingAnchorValue: CGFloat = -(.collectionViewMinimumLineSpacing / 2)
    static let collectionViewTrailingAnchorValue: CGFloat = collectionViewMinimumLineSpacing / 2
}

fileprivate extension String {
    static let collectionViewCellReuseIdentifier = "reuseID" // temporary value
}

fileprivate extension UIColor {
    
    // MARK: Background colors
    static let contentViewBackgroundColor = UIColor.clear
    static let collectionViewBackgroundColor = UIColor.clear
    
    // MARK: Dynamic colors
    static let mainViewBackgroungColorDynamic = UIColor { (traitCollection) -> UIColor in
        switch traitCollection.userInterfaceStyle {
        case .light:
            return .mainViewBackgroungColorLight
            
        case .dark:
            return .mainViewBackgroungColorDark
            
        default:
            print("Unsupported user interface style; \(NSString(#file).lastPathComponent):\(#line)")
            return .colorForUnknownInterfaceStyles
        }
    }
    
    static let pageControlIndicatorTintColorDynamic = UIColor { (traitCollection) -> UIColor in
            switch traitCollection.userInterfaceStyle {
            case .light:
                return .pageControlIndicatorTintColorLight
                
            case .dark:
                return .pageControlIndicatorTintColorDark
                
            default:
                print("Unsupported user interface style; \(NSString(#file).lastPathComponent):\(#line)")
                return .colorForUnknownInterfaceStyles
            }
    }
    
    static let pageControlCurrentIndicatorTintColorDynamic = UIColor { (traitCollection) -> UIColor in
        switch traitCollection.userInterfaceStyle {
        case .light:
            return .pageControlCurrentIndicatorTintColorLight
            
        case .dark:
            return .pageControlCurrentIndicatorTintColorDark
            
        default:
            print("Unsupported user interface style; \(NSString(#file).lastPathComponent):\(#line)")
            return .colorForUnknownInterfaceStyles
        }
    }
    
    // MARK: Colors for light/dark styles
    static let mainViewBackgroungColorLight = UIColor.white
    static let mainViewBackgroungColorDark = UIColor.black
    
    static let pageControlIndicatorTintColorLight = UIColor(white: 0.0, alpha: 0.2)
    static let pageControlIndicatorTintColorDark = UIColor(white: 1.0, alpha: 0.2)
    
    static let pageControlCurrentIndicatorTintColorLight = UIColor(white: 0.0, alpha: 1.0)
    static let pageControlCurrentIndicatorTintColorDark = UIColor(white: 1.0, alpha: 1.0)
    
    static let colorForUnknownInterfaceStyles = UIColor.red
}
