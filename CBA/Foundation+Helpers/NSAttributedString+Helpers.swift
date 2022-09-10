//
//  NSAttributedString+Highlight.swift
//  CBA
//
//  Created by Aravind R on 18/09/21.
//

import Foundation

extension NSAttributedString {
    func markText(_ text: String, with attribute: NSAttributedString.Key, value: Any = true) -> NSAttributedString {
        let rangeOfText = (self.string as NSString).range(of: text)

        let attributedString = self.mutable
        attributedString.addAttribute(attribute, value: value, range: rangeOfText)

        return attributedString
    }

    func applyAttributes(baseAttributes: [NSAttributedString.Key: Any]) -> NSAttributedString {
        let attributedString = self.mutable
        attributedString.addAttributes(baseAttributes, range: NSRange(location: 0, length: attributedString.length))
        return attributedString
    }

    func replaceAttribute(key: NSAttributedString.Key, with attributes: [NSAttributedString.Key: Any]) -> NSAttributedString {
        let attributedString = self.mutable
        attributedString.enumerateAttribute(key,
                                            in: NSRange(location: 0, length: attributedString.length),
                                            options: []) { attribute, range, _ in
            guard attribute != nil else {
                return
            }
            attributedString.setAttributes(attributes, range: range)
        }
        return attributedString
    }

    private var mutable: NSMutableAttributedString {
        NSMutableAttributedString(attributedString: self)
    }
}
