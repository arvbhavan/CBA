//
//  UIView+AutoLayout.swift
//  CBA
//
//  Created by Aravind R on 18/09/21.
//

import UIKit

extension UIView {
    func pin(to view: UIView, edgeInsets: UIEdgeInsets = .zero, ignoreSafeArea: Bool = false) {
        translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            topAnchor.constraint(equalTo: ignoreSafeArea ? view.topAnchor : view.safeAreaLayoutGuide.topAnchor, constant: edgeInsets.top),
            leadingAnchor.constraint(equalTo: ignoreSafeArea ? view.leadingAnchor : view.safeAreaLayoutGuide.leadingAnchor, constant: edgeInsets.left),
            bottomAnchor.constraint(equalTo: ignoreSafeArea ? view.bottomAnchor : view.safeAreaLayoutGuide.bottomAnchor, constant: -edgeInsets.bottom),
            trailingAnchor.constraint(equalTo: ignoreSafeArea ? view.trailingAnchor : view.safeAreaLayoutGuide.trailingAnchor, constant: -edgeInsets.right)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
