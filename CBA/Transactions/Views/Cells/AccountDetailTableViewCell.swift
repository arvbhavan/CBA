//
//  AccountDetailTableViewCell.swift
//  CBA
//
//  Created by Aravind R on 18/09/21.
//

import UIKit

final class AccountDetailTableViewCell: UITableViewCell {
    
    private enum LayoutConstants {
        static let textContentInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        static let cellContentInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    }

    // MARK: UI Elements
    
    private lazy var parentContainerView = UIView()
    
    // Top Stack View - holds `Account image`
    private lazy var imageStackView: UIStackView = {
        let imageStackView = UIStackView(arrangedSubviews: [accountImageView])
        imageStackView.axis = .horizontal
        imageStackView.alignment = .top
        imageStackView.distribution = .fill
        imageStackView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageStackView
    }()
    
    // Top Stack View - holds `Account Name Label` & `Account Number Label`
    private lazy var topStackView: UIStackView = {
        let labelsContainerStackView = UIStackView(arrangedSubviews: [accountNameLabel, accountNumberLabel])
        labelsContainerStackView.axis = .vertical
        labelsContainerStackView.alignment = .leading
        labelsContainerStackView.distribution = .fill
        labelsContainerStackView.spacing = 5
        
        let topStackView = UIStackView(arrangedSubviews: [imageStackView, labelsContainerStackView])
        topStackView.axis = .horizontal
        topStackView.alignment = .center
        topStackView.distribution = .fill
        topStackView.spacing = 30
        
        return topStackView
    }()
    
    // Background view aligning all edges to `topStackView` to hold a background color
    private lazy var topBackgroundView: UIView = {
        let topBackgroundView = UIView()
        topBackgroundView.backgroundColor = .cba_whiteBackground
        topBackgroundView.translatesAutoresizingMaskIntoConstraints = false

        return topBackgroundView
    }()
    
    // Bottom Stack View - Holds Available funds container view & Account Balance Container View
    private lazy var bottomStackView: UIStackView = {
        let fundsLabelContainingView = UIView()
        fundsLabelContainingView.translatesAutoresizingMaskIntoConstraints = false
        fundsLabelContainingView.addSubview(availableFundsTitleLabel)
        fundsLabelContainingView.addSubview(availableFundsValueLabel)

        let fundsLabelConstraints: [NSLayoutConstraint] = [
            availableFundsTitleLabel.topAnchor.constraint(equalTo: fundsLabelContainingView.topAnchor),
            availableFundsTitleLabel.leadingAnchor.constraint(equalTo: fundsLabelContainingView.leadingAnchor),
            availableFundsTitleLabel.bottomAnchor.constraint(equalTo: fundsLabelContainingView.bottomAnchor),
            availableFundsValueLabel.topAnchor.constraint(equalTo: fundsLabelContainingView.topAnchor),
            availableFundsValueLabel.trailingAnchor.constraint(equalTo: fundsLabelContainingView.trailingAnchor),
            availableFundsValueLabel.bottomAnchor.constraint(equalTo: fundsLabelContainingView.bottomAnchor),
            availableFundsValueLabel.leadingAnchor.constraint(equalTo: availableFundsTitleLabel.trailingAnchor, constant: 10)
        ]
        NSLayoutConstraint.activate(fundsLabelConstraints)
        
        let availableBalanceLabelContainingView = UIView()
        availableBalanceLabelContainingView.translatesAutoresizingMaskIntoConstraints = false
        availableBalanceLabelContainingView.addSubview(accountBalanceTitleLabel)
        availableBalanceLabelContainingView.addSubview(accountBalanceValueLabel)

        let availableBalanceLabelConstraints: [NSLayoutConstraint] = [
            accountBalanceTitleLabel.topAnchor.constraint(equalTo: availableBalanceLabelContainingView.topAnchor),
            accountBalanceTitleLabel.leadingAnchor.constraint(equalTo: availableBalanceLabelContainingView.leadingAnchor),
            accountBalanceTitleLabel.bottomAnchor.constraint(equalTo: availableBalanceLabelContainingView.bottomAnchor),
            accountBalanceValueLabel.topAnchor.constraint(equalTo: availableBalanceLabelContainingView.topAnchor),
            accountBalanceValueLabel.trailingAnchor.constraint(equalTo: availableBalanceLabelContainingView.trailingAnchor),
            accountBalanceValueLabel.bottomAnchor.constraint(equalTo: availableBalanceLabelContainingView.bottomAnchor),
            accountBalanceValueLabel.leadingAnchor.constraint(equalTo: accountBalanceTitleLabel.trailingAnchor, constant: 10)
        ]
        NSLayoutConstraint.activate(availableBalanceLabelConstraints)
                
        let labelsContainerStackView = UIStackView(arrangedSubviews: [fundsLabelContainingView, availableBalanceLabelContainingView])
        labelsContainerStackView.axis = .vertical
        labelsContainerStackView.distribution = .fill
        labelsContainerStackView.alignment = .fill
        labelsContainerStackView.spacing = 5
        
        let bottomStackView = UIStackView(arrangedSubviews: [spacerViewToOccupyImageViewWidth, labelsContainerStackView])
        bottomStackView.axis = .horizontal
        bottomStackView.distribution = .fill
        bottomStackView.alignment = .fill
        bottomStackView.spacing = 30
        
        return bottomStackView
    }()
    
    // Background view aligning all edges to `bottomStackView` to hold a background color
    private lazy var bottomBackgroundView: UIView = {
        let bottomBackgroundView = UIView()
        bottomBackgroundView.backgroundColor = .cba_greyBackground
        bottomBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        bottomBackgroundView.translatesAutoresizingMaskIntoConstraints = false

        return bottomBackgroundView
    }()
    
    private lazy var containerStackView: UIView = {
        let containerStackView = UIStackView(arrangedSubviews: [topBackgroundView, separatorView, bottomBackgroundView])
        containerStackView.axis = .vertical
        containerStackView.alignment = .fill
        containerStackView.distribution = .fill
        
        return containerStackView
    }()
    
    private lazy var accountImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "accounts")
        imageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()
    
    private lazy var accountNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        label.font = .cba_helveticaNeueLightBody
        label.textColor = .cba_primaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    
    private lazy var accountNumberLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        label.font = .cba_helveticaNeueLightSubhead
        label.textColor = .cba_secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    
    private lazy var availableFundsTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        label.setContentHuggingPriority(.defaultLow - 1, for: .horizontal)
        label.font = .cba_helveticaNeueLightSubhead
        label.textColor = .cba_secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    
    private lazy var availableFundsValueLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .right
        label.adjustsFontForContentSizeCategory = true
        label.setContentCompressionResistancePriority(.defaultHigh + 1, for: .horizontal)
        label.font = .cba_helveticaNeueBoldSubhead
        label.textColor = .cba_primaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    
    private lazy var accountBalanceTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        label.setContentHuggingPriority(.defaultLow - 1, for: .horizontal)
        label.font = .cba_helveticaNeueLightSubhead
        label.textColor = .cba_secondaryLabel
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    
    private lazy var accountBalanceValueLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .right
        label.adjustsFontForContentSizeCategory = true
        label.setContentCompressionResistancePriority(.defaultHigh + 1, for: .horizontal)
        label.font = .cba_helveticaNeueBoldSubhead
        label.textColor = .cba_secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .cba_separator
        view.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()
    
    private lazy var spacerViewToOccupyImageViewWidth: UIView = makeSpacerView()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .cba_greenBackground
        selectionStyle = .none
        accessibilityTraits = .header
        
        topBackgroundView.addSubview(topStackView)
        topStackView.pin(to: topBackgroundView, edgeInsets: LayoutConstants.textContentInsets)
        
        bottomBackgroundView.addSubview(bottomStackView)
        bottomStackView.pin(to: bottomBackgroundView, edgeInsets: LayoutConstants.textContentInsets)
        
        parentContainerView.addSubview(containerStackView)
        
        addSubview(parentContainerView)
        
        parentContainerView.pin(to: self, edgeInsets: LayoutConstants.cellContentInsets)
        containerStackView.pin(to: parentContainerView)
        spacerViewToOccupyImageViewWidth.widthAnchor.constraint(equalTo: accountImageView.widthAnchor).isActive = true
    }
}

// MARK: Helper functions

private extension AccountDetailTableViewCell {
    func makeSpacerView() -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }
}

// MARK: CellConfigurable conformation

extension AccountDetailTableViewCell {
    func configure(with viewModel: AccountDetailCellViewModel, indexPath: IndexPath) {
        accountNameLabel.text = viewModel.accountName
        accountNumberLabel.text = viewModel.accountNumber
        availableFundsTitleLabel.text = viewModel.availableFundsTitle
        availableFundsValueLabel.text = viewModel.availableFundsText
        accountBalanceTitleLabel.text = viewModel.accountBalanceTitle
        accountBalanceValueLabel.text = viewModel.accountBalanceText

        isAccessibilityElement = true
        accessibilityLabel = viewModel.cellAccessibilityText
        
        configureForAutomation(indexPath)
    }

    private func configureForAutomation(_ indexPath: IndexPath) {
        accessibilityIdentifier = "\(AccountDetailTableViewCell.self)"
        accountNameLabel.accessibilityIdentifier = "\(AccountDetailTableViewCell.self).accountNameLabel"
        accountNumberLabel.accessibilityIdentifier = "\(AccountDetailTableViewCell.self).accountNumberLabel"
        availableFundsTitleLabel.accessibilityIdentifier = "\(AccountDetailTableViewCell.self).availableFundsTitleLabel"
        availableFundsValueLabel.accessibilityIdentifier = "\(AccountDetailTableViewCell.self).availableFundsValueLabel"
        accountBalanceTitleLabel.accessibilityIdentifier = "\(AccountDetailTableViewCell.self).accountBalanceTitleLabel"
        accountBalanceValueLabel.accessibilityIdentifier = "\(AccountDetailTableViewCell.self).accountBalanceValueLabel"
    }
}
