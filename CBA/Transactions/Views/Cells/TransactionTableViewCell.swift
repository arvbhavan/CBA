//
//  TransactionTableViewCell.swift
//  CBA
//
//  Created by Aravind R on 18/09/21.
//

import UIKit

final class TransactionTableViewCell: UITableViewCell {

    private enum LayoutConstants {
        static let imageViewWidth: CGFloat = 30
        static let imageViewHeight: CGFloat = 50
        static let cellContentInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    }
    
    // MARK: - UI components
    
    private lazy var atmImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "findUs")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.accessibilityTraits = .image
        imageView.isAccessibilityElement = true
        imageView.accessibilityLabel = "ATM Location"
        let widthConstraint = imageView.widthAnchor.constraint(equalToConstant: LayoutConstants.imageViewWidth)

        NSLayoutConstraint.activate([widthConstraint])

        return imageView
    }()
    
    private lazy var detailLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    
    private lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultHigh+1, for: .horizontal)
        label.adjustsFontForContentSizeCategory = true
        label.font = .cba_helveticaNeueBoldSubhead
        label.textColor = .cba_primaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .cba_whiteBackground

        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)
        
        containerView.addSubview(atmImageView)
        containerView.addSubview(detailLabel)
        containerView.addSubview(amountLabel)
        
        let containerViewConstraints: [NSLayoutConstraint] = [
            atmImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            atmImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            atmImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),

            detailLabel.leadingAnchor.constraint(equalTo: atmImageView.trailingAnchor, constant: 15),

            detailLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            detailLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),

            amountLabel.leadingAnchor.constraint(equalTo: detailLabel.trailingAnchor, constant: 15),
            
            amountLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            amountLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            amountLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ]
        NSLayoutConstraint.activate(containerViewConstraints)
        
        containerView.pin(to: self, edgeInsets: LayoutConstants.cellContentInsets)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        atmImageView.isHidden = false
        detailLabel.text = nil
        amountLabel.text = nil
    }
}

extension TransactionTableViewCell {
    func configure(with viewModel: TransactionCellViewModel, indexPath: IndexPath) {
        atmImageView.isHidden = !viewModel.hasATMInformation
        
        let attributedTransactionDescription = viewModel.transactionDetailText
        let baseAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.cba_primaryLabel,
            .font: UIFont.cba_helveticaNeueLightSubhead
        ]
        let highlightAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.cba_helveticaNeueBoldSubhead
        ]
        
        detailLabel.attributedText = attributedTransactionDescription
            .applyAttributes(baseAttributes: baseAttributes)
            .replaceAttribute(key: .pendingTransactionHighlight, with: highlightAttributes)
        
        amountLabel.text = viewModel.balanceText
        selectionStyle = viewModel.hasATMInformation ? .default : .none
        accessibilityHint = viewModel.hasATMInformation ? "Double tap to view ATM location" : nil
        isAccessibilityElement = true
        accessibilityLabel = viewModel.cellAccessibilityText

        configureForAutomation(indexPath)
    }
    
    private func configureForAutomation(_ indexPath: IndexPath) {
        accessibilityIdentifier = "\(TransactionTableViewCell.self)-section-\(indexPath.section)-row-\(indexPath.row)"
        atmImageView.accessibilityIdentifier = "\(TransactionTableViewCell.self).atmImageView"
        detailLabel.accessibilityIdentifier = "\(TransactionTableViewCell.self).detailLabel"
        amountLabel.accessibilityIdentifier = "\(TransactionTableViewCell.self).amountLabel"
    }
}
