//
//  CurrencyRateCollectionViewCell.swift
//  currenc.io
//
//  Created by Ostap on 03.04.2020.
//  Copyright © 2020 Ostap Tyvonovych. All rights reserved.
//

import UIKit
import CorePlot

class CurrencyRateCollectionViewCell: UICollectionViewCell, Setuppable, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDataSource, CPTScatterPlotDataSource, CPTScatterPlotDelegate {
    
    enum TimeframeOption: String, CaseIterable {
        case seconds15 = "15s"
        case seconds30 = "30s"
        case seconds60 = "60s"
        case day = "Day"
        case week = "Week"
        case month = "Month"
    }
    
    private var currentTimeframeOption = TimeframeOption.seconds15
    
    private var scrollView: UIScrollView!
    private var scrollContentView: UIView!
    private var currencyTitleContainerView: UIView!
    private var currencyIconImageView: UIImageView!
    private var currencyTitleTextView: UITextView!
    private var graphHostingView: CPTGraphHostingView!
    private var currencyChangeIndicatorContainerView: UIView!
    private var currencyChangeIndicatorLabel: UILabel!
    private var currencyChangeIndicatorShape: UIView!
    private var timeframeButtonsCollectionView: UICollectionView!
    private var tableView: UITableView!
    private var placeholderView: UIView!
    
    private var commonConstraints = [NSLayoutConstraint]()

    private var isInterfaceInitialized = false
    
    // MARK: - Setup cell
    
    func setupInstance() {
        if !isInterfaceInitialized {
            setupInterface()
        }
        
        let item = TimeframeOption.allCases.firstIndex(of: currentTimeframeOption)!
        let indexPath = IndexPath(item: item, section: 0)
        timeframeButtonsCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .left)
    }
    
    // MARK: - Setup interface
    
    private func setupInterface() {
        initializeInterface()
        setupViewHierarchy()
        constraintInterface()
    }
    
    // MARK: - Initalize UI
    
    private func initializeInterface() {
        scrollView = makeScrollView()
        scrollContentView = makeScrollContentView()
        currencyTitleContainerView = makeCurrencyTitleContainerView()
        currencyIconImageView = makeCurrencyIconImageView()
        currencyTitleTextView = makeCurrencyTitleTextView()
        graphHostingView = makeGraphHostingView()
        currencyChangeIndicatorContainerView = makeCurrencyChangeIndicatorContainerView()
        currencyChangeIndicatorLabel = makeCurrencyChangeIndicatorLabel()
        currencyChangeIndicatorShape = makeCurrencyChangeIndicatorShape()
        timeframeButtonsCollectionView = makeTimeframeButtonsCollectionView()
        tableView = makeTableView()
        placeholderView = makePlaceholderView()
        
        isInterfaceInitialized = true
    }
    
    private func makeScrollView() -> UIScrollView {
        let scrollView = UIScrollView()
        return scrollView
    }
    
    private func makeScrollContentView() -> UIView {
        let scrollContentView = UIView()
        return scrollContentView
    }
    
    private func makeCurrencyTitleContainerView() -> UIView {
        let currencyTitleContainerView = UIView()
        return currencyTitleContainerView
    }
    
    private func makeCurrencyIconImageView() -> UIImageView {
        let currencyIconImageView = UIImageView()
        return currencyIconImageView
    }
    
    private func makeCurrencyTitleTextView() -> UITextView {
        let currencyTitleTextView = UITextView()
        currencyTitleTextView.attributedText = makeCurrencyTitle()
        currencyTitleTextView.isScrollEnabled = false
        currencyTitleTextView.textContainerInset = .zero
        currencyTitleTextView.textContainer.maximumNumberOfLines = 0
        currencyTitleTextView.backgroundColor = .currencyTitleTextViewBackgroundColor
        
        return currencyTitleTextView
    }
    
    private func makeCurrencyTitle() -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString()
        
        let currencyNameString = NSAttributedString(string: .currencyNameString, attributes: [.font: UIFont.currencyNameFont, .foregroundColor: UIColor.currencyNameColor])
        let currencyPriceString = NSAttributedString(string: .currencyPriceString, attributes: [.font: UIFont.currencyPriceFont, .foregroundColor: UIColor.currencyPriceColor])
        let spaceBetweenTexts = NSAttributedString(string: .spaceBetweenTexts, attributes: [.font: UIFont.spaceBetweenTextsFont])
        
        mutableAttributedString.append(currencyNameString)
        mutableAttributedString.append(spaceBetweenTexts)
        mutableAttributedString.append(currencyPriceString)
        
        return mutableAttributedString.copy() as! NSAttributedString
    }
    
    private func makeGraphHostingView() -> CPTGraphHostingView {
        let hostingView = CPTGraphHostingView()
        
        let graph = CPTXYGraph()
        graph.axisSet!.isHidden = true
        graph.paddingTop = .graphPaddingTop
        graph.paddingRight = .graphPaddingRight
        graph.paddingBottom = .graphPaddingBottom
        graph.paddingLeft = .graphPaddingLeft
        
        hostingView.hostedGraph = graph
        
        let lineStyle = CPTMutableLineStyle()
        lineStyle.lineColor = CPTColor(cgColor: UIColor.graphLineColor.cgColor)
        lineStyle.lineWidth = .graphLineWidth
        
        let xAxisMin = Double.graphXAxisMinValue
        let xAxisMax = Double.graphXAxisMaxValue
        let yAxisMin = Double.graphYAxisMinValue
        let yAxisMax = Double.graphYAxisMaxValue

        let plotSpace = graph.defaultPlotSpace as! CPTXYPlotSpace
        plotSpace.xRange = CPTPlotRange(locationDecimal: Decimal(xAxisMin), lengthDecimal: Decimal(xAxisMax - xAxisMin))
        plotSpace.yRange = CPTPlotRange(locationDecimal: Decimal(yAxisMin), lengthDecimal: Decimal(yAxisMax - yAxisMin))
        
        let fillColor = CPTColor(cgColor: UIColor.graphAreaFillColor.cgColor)
        let fill = CPTFill(color: fillColor)
        
        let plot = CPTScatterPlot()
        plot.dataSource = self
        plot.dataLineStyle = lineStyle
        plot.areaFill = fill
        plot.areaBaseValue = NSNumber(cgFloat: .areaBaseValue)
        
        graph.add(plot)
        
        return hostingView
    }
    
    private func makeCurrencyChangeIndicatorContainerView() -> UIView {
        let currencyChangeIndicatorContainerView = UIView()
        currencyChangeIndicatorContainerView.backgroundColor = .currencyChangeIndicatorContainerViewBackgroundColor
        
        return currencyChangeIndicatorContainerView
    }
    
    private func makeCurrencyChangeIndicatorLabel() -> UILabel {
        let currencyChangeIndicatorLabel = UILabel()
        currencyChangeIndicatorLabel.textColor = .currencyChangeIndicatorLabelTextColor
        currencyChangeIndicatorLabel.text = .currencyChangeIndicatorLabelString
        currencyChangeIndicatorLabel.font = .currencyChangeIndicatorLabelFont
        
        return currencyChangeIndicatorLabel
    }
    
    private func makeCurrencyChangeIndicatorShape() -> UIView {
        let currencyChangeIndicatorShape = UIView()
        currencyChangeIndicatorShape.backgroundColor = .currencyChangeIndicatorShapeBackgroundColor
        currencyChangeIndicatorShape.layer.cornerRadius = .currencyChangeIndicatorShapeCornerRadius
        
        return currencyChangeIndicatorShape
    }
    
    private func makeTimeframeButtonsCollectionView() -> UICollectionView {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        flowLayout.minimumLineSpacing = 0.0
        flowLayout.minimumInteritemSpacing = 0.0
        
        let timeframeButtonsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        timeframeButtonsCollectionView.backgroundColor = .currencyInfoBackgroundColor
        timeframeButtonsCollectionView.dataSource = self
        timeframeButtonsCollectionView.delegate = self
        timeframeButtonsCollectionView.showsHorizontalScrollIndicator = false
        
        timeframeButtonsCollectionView.register(TimeframeButtonCollectionViewCell.self, forCellWithReuseIdentifier: .timeframeButtonCellReuseIdentifier)
        
        return timeframeButtonsCollectionView
    }
    
    private func makeTableView() -> UITableView {
        let tableView = UITableView()
        tableView.backgroundColor = .currencyInfoBackgroundColor
        tableView.dataSource = self
        tableView.separatorInset = UIEdgeInsets(top: .tableViewSeparatorInsetTopValue, left: .tableViewSeparatorInsetLeftValue, bottom: .tableViewSeparatorInsetBottomValue, right: .tableViewSeparatorInsetRightValue)
        tableView.isUserInteractionEnabled = false
        
        tableView.register(CurrencyInfoTableViewCell.self, forCellReuseIdentifier: .currencyInfoCellReuseIdentifier)
        
        return tableView
    }
    
    private func makePlaceholderView() -> UIView {
        let placeholderView = UIView()
        placeholderView.backgroundColor = .currencyInfoBackgroundColor
        
        return placeholderView
    }
    
    // MARK: - Make up view hierarchy
    
    private func setupViewHierarchy() {
        self.contentView.addSubview(scrollView)
        scrollView.addSubview(scrollContentView)
        scrollContentView.addSubview(currencyTitleContainerView)
        currencyTitleContainerView.addSubview(currencyIconImageView)
        currencyTitleContainerView.addSubview(currencyTitleTextView)
        scrollContentView.addSubview(graphHostingView)
        scrollContentView.addSubview(currencyChangeIndicatorContainerView)
        currencyChangeIndicatorContainerView.addSubview(currencyChangeIndicatorShape)
        currencyChangeIndicatorShape.addSubview(currencyChangeIndicatorLabel)
        scrollContentView.addSubview(timeframeButtonsCollectionView)
        scrollContentView.addSubview(tableView)
        scrollContentView.addSubview(placeholderView)
    }
    
    // MARK: - Setup constraints
    
    private func constraintInterface() {
        constraintScrollView(scrollView)
        constraintScrollContentView(scrollContentView)
        constraintCurrencyTitleContainerView(currencyTitleContainerView)
        constraintCurrencyIconImageView(currencyIconImageView)
        constraintCurrencyTitleTextView(currencyTitleTextView)
        constraintGraphHostingView(graphHostingView)
        constraintCurrencyChangeIndicatorContainerView(currencyChangeIndicatorContainerView)
        constraintCurrencyChangeIndicatorShape(currencyChangeIndicatorShape)
        constraintCurrencyChangeIndicatorLabel(currencyChangeIndicatorLabel)
        constraintTimeframeButtonsCollectionView(timeframeButtonsCollectionView)
        constraintTableView(tableView)
        constraintPlaceholderView(placeholderView)
        
        NSLayoutConstraint.activate(commonConstraints)
    }
    
    private func constraintScrollView(_ scrollView: UIView) {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        commonConstraints.append(contentsOf: [
            scrollView.topAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.topAnchor, constant: .scrollViewTopAnchorValue),
            scrollView.bottomAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.bottomAnchor, constant: .scrollViewBottomAnchorValue),
            scrollView.leadingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.leadingAnchor, constant: .scrollViewLeadingAnchorValue),
            scrollView.trailingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.trailingAnchor, constant: .scrollViewTrailingAnchorValue)
        ])
    }
    
    private func constraintScrollContentView(_ scrollContentView: UIView) {
        scrollContentView.translatesAutoresizingMaskIntoConstraints = false
        
        let heightAnchor = scrollContentView.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor, constant: .scrollContentViewHeightAnchorValue)
        heightAnchor.priority = .defaultLow
        
        commonConstraints.append(contentsOf: [
            scrollContentView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: .scrollContentViewTopAnchorValue),
            scrollContentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: .scrollContentViewBottomAnchorValue),
            scrollContentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: .scrollContentViewLeadingAnchorValue),
            scrollContentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: .scrollContentViewTrailingAnchorValue),
            scrollContentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: .scrollContentViewWidthAnchorValue),
            heightAnchor
        ])
    }
    
    private func constraintCurrencyTitleContainerView(_ currencyTitleContainerView: UIView) {
        currencyTitleContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        let heightAnchor = currencyTitleContainerView.heightAnchor.constraint(equalToConstant: .currencyTitleContainerViewHeightAnchorValue)
        heightAnchor.priority = .defaultLow
        
        commonConstraints.append(contentsOf: [
            currencyTitleContainerView.topAnchor.constraint(equalTo: scrollContentView.safeAreaLayoutGuide.topAnchor, constant: .currencyTitleContainerViewTopAnchorValue),
            currencyTitleContainerView.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: .currencyTitleContainerViewLeadingAnchorValue),
            currencyTitleContainerView.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: .currencyTitleContainerViewTrailingAnchorValue),
            heightAnchor
        ])
    }
    
    private func constraintCurrencyIconImageView(_ currencyIconImageView: UIView) {
        currencyIconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        commonConstraints.append(contentsOf: [
            currencyIconImageView.leadingAnchor.constraint(equalTo: currencyTitleContainerView.leadingAnchor, constant: .currencyIconImageViewLeadingAnchorValue),
            currencyIconImageView.centerYAnchor.constraint(equalTo: currencyTitleContainerView.centerYAnchor, constant: .currencyIconImageViewCenterYAnchorValue),
            currencyIconImageView.widthAnchor.constraint(equalToConstant: .currencyIconImageViewWidthAnchorValue),
            currencyIconImageView.heightAnchor.constraint(equalToConstant: .currencyIconImageViewHeightAnchorValue)
        ])
    }
    
    private func constraintCurrencyTitleTextView(_ currencyTitleTextView: UIView) {
        currencyTitleTextView.translatesAutoresizingMaskIntoConstraints = false
        
        commonConstraints.append(contentsOf: [
            currencyTitleTextView.topAnchor.constraint(equalTo: currencyTitleContainerView.topAnchor, constant: .currencyTitleTextViewTopAnchorValue),
            currencyTitleTextView.bottomAnchor.constraint(equalTo: currencyTitleContainerView.bottomAnchor, constant: .currencyTitleTextViewBottomAnchorValue),
            currencyTitleTextView.leadingAnchor.constraint(equalTo: currencyIconImageView.trailingAnchor, constant: .currencyTitleTextViewLeadingAnchorValue),
            currencyTitleTextView.centerYAnchor.constraint(equalTo: currencyIconImageView.centerYAnchor, constant: .currencyTitleTextViewCenterYAnchorValue)
        ])
    }
    
    private func constraintGraphHostingView(_ graphHostingView: UIView) {
        graphHostingView.translatesAutoresizingMaskIntoConstraints = false
        
        commonConstraints.append(contentsOf: [
            graphHostingView.topAnchor.constraint(equalTo: currencyTitleContainerView.bottomAnchor, constant: .graphHostingViewTopAnchorValue),
            graphHostingView.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: .graphHostingViewLeadingAnchorValue),
            graphHostingView.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: .graphHostingViewTrailingAnchorValue),
            graphHostingView.heightAnchor.constraint(equalToConstant: .graphHostingViewHeightAnchorValue)
        ])
    }
    
    private func constraintCurrencyChangeIndicatorContainerView(_ currencyChangeIndicatorContainerView: UIView) {
        currencyChangeIndicatorContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        commonConstraints.append(contentsOf: [
            currencyChangeIndicatorContainerView.topAnchor.constraint(equalTo: graphHostingView.bottomAnchor, constant: .currencyChangeIndicatorContainerViewTopAnchorValue),
            currencyChangeIndicatorContainerView.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: .currencyChangeIndicatorContainerViewLeadingAnchorValue),
            currencyChangeIndicatorContainerView.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: .currencyChangeIndicatorContainerViewTrailingAnchorValue),
            currencyChangeIndicatorContainerView.heightAnchor.constraint(equalToConstant: .currencyChangeIndicatorContainerViewHeightAnchorValue)
        ])
    }
    
    private func constraintCurrencyChangeIndicatorShape(_ currencyChangeIndicatorShape: UIView) {
        currencyChangeIndicatorShape.translatesAutoresizingMaskIntoConstraints = false
        
        commonConstraints.append(contentsOf: [
            currencyChangeIndicatorShape.topAnchor.constraint(equalTo: currencyChangeIndicatorContainerView.topAnchor, constant: .currencyChangeIndicatorLabelTopAnchorValue),
            currencyChangeIndicatorShape.bottomAnchor.constraint(equalTo: currencyChangeIndicatorContainerView.bottomAnchor, constant: .currencyChangeIndicatorLabelBottomAnchorValue),
            currencyChangeIndicatorShape.trailingAnchor.constraint(equalTo: currencyChangeIndicatorContainerView.trailingAnchor, constant: .currencyChangeIndicatorLabelTrailingAnchorValue),
            currencyChangeIndicatorShape.heightAnchor.constraint(equalToConstant: .currencyChangeIndicatorLabelHeightAnchorValue)
        ])
    }
    
    private func constraintCurrencyChangeIndicatorLabel(_ currencyChangeIndicatorLabel: UIView) {
        currencyChangeIndicatorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        commonConstraints.append(contentsOf: [
            currencyChangeIndicatorLabel.firstBaselineAnchor.constraint(equalTo: currencyChangeIndicatorShape.bottomAnchor, constant: .currencyChangeIndicatorShapeFirstBaselineAnchorValue),
            currencyChangeIndicatorLabel.centerYAnchor.constraint(equalTo: currencyChangeIndicatorShape.centerYAnchor, constant: .currencyChangeIndicatorShapeCenterYAnchorValue),
            currencyChangeIndicatorLabel.leadingAnchor.constraint(equalTo: currencyChangeIndicatorShape.leadingAnchor, constant: .currencyChangeIndicatorShapeLeadingAnchorValue),
            currencyChangeIndicatorLabel.centerXAnchor.constraint(equalTo: currencyChangeIndicatorShape.centerXAnchor, constant: .currencyChangeIndicatorShapeCenterXAnchorValue)
        ])
    }
    
    private func constraintTimeframeButtonsCollectionView(_ timeframeButtonsCollectionView: UIView) {
        timeframeButtonsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        commonConstraints.append(contentsOf: [
            timeframeButtonsCollectionView.topAnchor.constraint(equalTo: currencyChangeIndicatorContainerView.bottomAnchor, constant: .timeframeButtonsCollectionViewTopAnchorValue),
            timeframeButtonsCollectionView.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: .timeframeButtonsCollectionViewLeadingAnchorValue),
            timeframeButtonsCollectionView.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: .timeframeButtonsCollectionViewTrailingAnchorValue),
            timeframeButtonsCollectionView.heightAnchor.constraint(equalToConstant: .timeframeButtonsCollectionViewHeightAnchorValue)
        ])
    }
    
    private func constraintTableView(_ tableView: UIView) {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        commonConstraints.append(contentsOf: [
            tableView.topAnchor.constraint(equalTo: timeframeButtonsCollectionView.bottomAnchor, constant: .tableViewTopAnchorValue),
            tableView.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: .tableViewLeadingAnchorValue),
            tableView.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: .tableViewTrailingAnchorValue),
            tableView.heightAnchor.constraint(equalToConstant: .tableViewHeightAnchorValue)
        ])
    }
    
    private func constraintPlaceholderView(_ placeholderView: UIView) {
        placeholderView.translatesAutoresizingMaskIntoConstraints = false
        
        commonConstraints.append(contentsOf: [
            placeholderView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: .placeholderViewTopAnchorValue),
            placeholderView.bottomAnchor.constraint(equalTo: scrollContentView.bottomAnchor, constant: .placeholderViewBottomAnchorValue),
            placeholderView.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: .placeholderViewLeadingAnchorValue),
            placeholderView.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: .placeholderViewTrailingAnchorValue)
        ])
    }
    
    // MARK: - Collection view data source
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return TimeframeOption.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: .timeframeButtonCellReuseIdentifier, for: indexPath) as! TimeframeButtonCollectionViewCell
        cell.setupInstance()
        cell.titleText = TimeframeOption.allCases[indexPath.item].rawValue
        
        return cell
    }
    
    // MARK: - Collection view delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! TimeframeButtonCollectionViewCell
        
        currentTimeframeOption = TimeframeOption(rawValue: cell.titleText!)!
    }
    
    // MARK: - Table view delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4 // temporary
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: .currencyInfoCellReuseIdentifier, for: indexPath) as! CurrencyInfoTableViewCell
        cell.setupInstance()
        
        let style = NSMutableParagraphStyle()
        style.alignment = .right
        
        cell.contentView.backgroundColor = .currencyInfoBackgroundColor
        cell.titleLabel.attributedText = NSAttributedString(string: .currencyInfoCellTitleString, attributes: [.font: UIFont.currencyInfoCellTitleFont, .foregroundColor: UIColor.currencyInfoCellTitleColor])
        cell.valueLabel.attributedText = NSAttributedString(string: .currencyInfoCellValueString, attributes: [.font: UIFont.currencyInfoCellValueFont, .foregroundColor: UIColor.currencyInfoCellValueColor, .paragraphStyle: style])
        
        return cell
    }
    
    // MARK: - Scatter plot data source
    
    func numberOfRecords(for plot: CPTPlot) -> UInt {
        return UInt(100) // temporary
    }

    func number(for plot: CPTPlot, field fieldEnum: UInt, record idx: UInt) -> Any? {
        let plotField = CPTScatterPlotField(rawValue: Int(fieldEnum))! // in fact bridging step from ObjC enum to Swift enum
        
        switch plotField {
        case .X:
            return idx
        case .Y:
            return idx // temporary
        default:
            print("Unknown CPTScatterPlotField case (rawValue: \(fieldEnum)) passed to call \(#function), \(NSString(#file).lastPathComponent):\(#line)")
            return UInt(0)
        }
    }
}

// MARK: - Constants

fileprivate extension CGFloat {
    // MARK: Font sizes
    static let currencyNameFontSize: CGFloat = 34.0
    static let currencyPriceFontSize: CGFloat = 24.0
    static let spaceBetweenTextsFontSize: CGFloat = 1.0
    static let currencyChangeIndicatorLabelFontSize: CGFloat = 14.0
    static let currencyInfoCellTitleFontSize: CGFloat = 14.0
    static let currencyInfoCellValueFontSize: CGFloat = 14.0
    
    // MARK: Graph hosting view constants
    static let graphPaddingTop: CGFloat = 0.0
    static let graphPaddingRight: CGFloat = -5.0
    static let graphPaddingBottom: CGFloat = 0.0
    static let graphPaddingLeft: CGFloat = 0.0
    
    static let graphLineWidth: CGFloat = 3.0
    static let areaBaseValue: CGFloat = 0.0
    
    // MARK: Currency change indicator shape constants
    static let currencyChangeIndicatorShapeCornerRadius: CGFloat = .currencyChangeIndicatorLabelHeightAnchorValue / 2
    
    // MARK: Table view constants
    static let tableViewSeparatorInsetTopValue: CGFloat = 0.0
    static let tableViewSeparatorInsetLeftValue: CGFloat = 16.0
    static let tableViewSeparatorInsetBottomValue: CGFloat = 0.0
    static let tableViewSeparatorInsetRightValue: CGFloat = 0.0

    // MARK: Constraint values
    static let scrollViewTopAnchorValue: CGFloat = 0.0
    static let scrollViewBottomAnchorValue: CGFloat = 0.0
    static let scrollViewLeadingAnchorValue: CGFloat = 0.0
    static let scrollViewTrailingAnchorValue: CGFloat = 0.0
    
    static let scrollContentViewTopAnchorValue: CGFloat = 0.0
    static let scrollContentViewBottomAnchorValue: CGFloat = 0.0
    static let scrollContentViewLeadingAnchorValue: CGFloat = 0.0
    static let scrollContentViewTrailingAnchorValue: CGFloat = 0.0
    static let scrollContentViewWidthAnchorValue: CGFloat = 0.0
    static let scrollContentViewHeightAnchorValue: CGFloat = 0.0
    
    static let currencyTitleContainerViewTopAnchorValue: CGFloat = 5.0
    static let currencyTitleContainerViewLeadingAnchorValue: CGFloat = 0.0
    static let currencyTitleContainerViewTrailingAnchorValue: CGFloat = 0.0
    static let currencyTitleContainerViewHeightAnchorValue: CGFloat = 66.0
    
    static let currencyIconImageViewLeadingAnchorValue: CGFloat = 16.0
    static let currencyIconImageViewCenterYAnchorValue: CGFloat = 0.0
    static let currencyIconImageViewWidthAnchorValue: CGFloat = 60.0
    static let currencyIconImageViewHeightAnchorValue: CGFloat = 60.0
    
    static let currencyTitleTextViewTopAnchorValue: CGFloat = 0.0
    static let currencyTitleTextViewBottomAnchorValue: CGFloat = 0.0
    static let currencyTitleTextViewLeadingAnchorValue: CGFloat = 12.5
    static let currencyTitleTextViewCenterYAnchorValue: CGFloat = 0.0
    
    static let graphHostingViewTopAnchorValue: CGFloat = 16.0
    static let graphHostingViewLeadingAnchorValue: CGFloat = 0.0
    static let graphHostingViewTrailingAnchorValue: CGFloat = 0.0
    static let graphHostingViewHeightAnchorValue: CGFloat = 172.0
    
    static let currencyChangeIndicatorContainerViewTopAnchorValue: CGFloat = 0.0
    static let currencyChangeIndicatorContainerViewLeadingAnchorValue: CGFloat = 0.0
    static let currencyChangeIndicatorContainerViewTrailingAnchorValue: CGFloat = 0.0
    static let currencyChangeIndicatorContainerViewHeightAnchorValue: CGFloat = 67.5
    
    static let currencyChangeIndicatorLabelTopAnchorValue: CGFloat = 19.0
    static let currencyChangeIndicatorLabelBottomAnchorValue: CGFloat = -19.0
    static let currencyChangeIndicatorLabelTrailingAnchorValue: CGFloat = -16.0
    static let currencyChangeIndicatorLabelHeightAnchorValue: CGFloat = 29.0
    
    static let currencyChangeIndicatorShapeFirstBaselineAnchorValue: CGFloat = -10.0
    static let currencyChangeIndicatorShapeCenterYAnchorValue: CGFloat = 0.0
    static let currencyChangeIndicatorShapeLeadingAnchorValue: CGFloat = 11.0
    static let currencyChangeIndicatorShapeCenterXAnchorValue: CGFloat = 0.0
    
    static let timeframeButtonsCollectionViewTopAnchorValue: CGFloat = 0.0
    static let timeframeButtonsCollectionViewLeadingAnchorValue: CGFloat = 0.0
    static let timeframeButtonsCollectionViewTrailingAnchorValue: CGFloat = 0.0
    static let timeframeButtonsCollectionViewHeightAnchorValue: CGFloat = 51.0
    
    static let tableViewTopAnchorValue: CGFloat = 0.0
    static let tableViewLeadingAnchorValue: CGFloat = 0.0
    static let tableViewTrailingAnchorValue: CGFloat = 0.0
    static let tableViewHeightAnchorValue: CGFloat = 200.0
    
    static let placeholderViewTopAnchorValue: CGFloat = 0.0
    static let placeholderViewBottomAnchorValue: CGFloat = 0.0
    static let placeholderViewLeadingAnchorValue: CGFloat = 0.0
    static let placeholderViewTrailingAnchorValue: CGFloat = 0.0
}

fileprivate extension Double {
    // MARK: Graph hosting view constants
    static let graphXAxisMinValue = 0.0
    static let graphXAxisMaxValue = 100.0
    static let graphYAxisMinValue = 0.0
    static let graphYAxisMaxValue = 100.0
}

fileprivate extension UIFont {
    // MARK: Currency title fonts
    static let currencyNameFont = UIFont.systemFont(ofSize: .currencyNameFontSize, weight: .bold)
    static let currencyPriceFont = UIFont.systemFont(ofSize: .currencyPriceFontSize, weight: .medium)
    static let spaceBetweenTextsFont = UIFont.systemFont(ofSize: .spaceBetweenTextsFontSize, weight: .bold)
    
    // MARK: Currency change label fonts
    static let currencyChangeIndicatorLabelFont = UIFont.systemFont(ofSize: .currencyChangeIndicatorLabelFontSize, weight: .semibold)
    
    // MARK: Currency info cell fonts
    static let currencyInfoCellTitleFont = UIFont.systemFont(ofSize: .currencyInfoCellTitleFontSize, weight: .medium)
    static let currencyInfoCellValueFont = UIFont.systemFont(ofSize: .currencyInfoCellValueFontSize, weight: .semibold)
}

fileprivate extension UIColor {
    // MARK: Text colors
    static let currencyNameColor = UIColor.white
    static let currencyPriceColor = UIColor(hex: "77C338")!
    static let currencyChangeIndicatorLabelTextColor = UIColor.white
    
    // MARK: Graph colors
    static let graphAreaFillColor = UIColor.white.withAlphaComponent(0.050)
    static let graphLineColor = UIColor.white
    
    // MARK: Background colors
    static let currencyTitleTextViewBackgroundColor = UIColor.clear
    static let currencyChangeIndicatorContainerViewBackgroundColor = UIColor.white.withAlphaComponent(0.055)
    static let currencyChangeIndicatorShapeBackgroundColor = UIColor(hex: "72B637")!
    static let currencyInfoBackgroundColor = UIColor(hex: "05060A")!
    
    // MARK: Currency info cell colors
    static let currencyInfoCellTitleColor = UIColor(hex: "434650")!
    static let currencyInfoCellValueColor = UIColor(hex: "56BA2E")!
}

fileprivate extension String {
    // MARK: Reuse identifiers
    static let currencyInfoCellReuseIdentifier = String(describing: CurrencyInfoTableViewCell.self)
    static let timeframeButtonCellReuseIdentifier = String(describing: TimeframeButtonCollectionViewCell.self)
    
    // MARK: Currency title strings (TEMPORARY)
    static let currencyNameString = "Bitcoin"
    static let currencyPriceString = "$6.564,30"
    static let spaceBetweenTexts = "\n"
    
    // MARK: Currency change strings (TEMPORARY)
    static let currencyChangeIndicatorLabelString = "7.12 %"
    
    // MARK: Currency info strings (TEMPORARY)
    static let currencyInfoCellTitleString = "Market Cap"
    static let currencyInfoCellValueString = "+%24,95"
}
