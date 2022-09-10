//
//  TransactionSectionHeaderView.swift
//  CBA
//
//  Created by Aravind R on 18/09/21.
//

import UIKit

final class TransactionSectionHeaderView: UITableViewHeaderFooterView {
    
    private enum LayoutConstants {
        static let cellContentInsets = UIEdgeInsets(top: 5, left: 16, bottom: 5, right: 16)
    }
    
    // MARK: UI elements
    
    private lazy var backgroundColorView: UIView = UIView()
    
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [dateLabel, timelineLabel])
        stackView.alignment = .fill
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false

        return stackView
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = .cba_helveticaNeueBoldSubhead
        label.textColor = .cba_primaryLabel
        label.accessibilityIdentifier = "\(TransactionSectionHeaderView.self).dateLabel"

        return label
    }()
    
    private lazy var timelineLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = .cba_helveticaNeueBoldSubhead
        label.textColor = .cba_primaryLabel
        label.accessibilityIdentifier = "\(TransactionSectionHeaderView.self).timelineLabel"

        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        dateLabel.text = nil
        timelineLabel.text = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColorView.backgroundColor = .cba_yellowBackground
        addSubview(backgroundColorView)
        backgroundColorView.pin(to: self, ignoreSafeArea: true)
        backgroundColorView.preservesSuperviewLayoutMargins = false

        addSubview(containerStackView)
        containerStackView.pin(to: self, edgeInsets: LayoutConstants.cellContentInsets)
    }
}

// MARK: SectionHeaderFooterConfigurable implementation

extension TransactionSectionHeaderView {
    func configure(with viewModel: TransactionSectionHeaderViewModel, section: Int) {
        dateLabel.text = viewModel.dateString
        timelineLabel.text = viewModel.timelineText
        
        // Set accessibility
        accessibilityLabel = viewModel.cellAccessibilityText
    }
}
