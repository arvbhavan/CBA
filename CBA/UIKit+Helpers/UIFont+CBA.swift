//
//  UIFont+CBA.swift
//  CBA
//
//  Created by Aravind R on 18/09/21.
//

import UIKit

extension UIFont {
    static var cba_helveticaNeueLightBody: UIFont {
        let font = UIFont(name: "HelveticaNeue-Light", size: 18)!
        let fontMetrics = UIFontMetrics(forTextStyle: .body)

        return fontMetrics.scaledFont(for: font)
    }

    static var cba_helveticaNeueLightSubhead: UIFont {
        let font = UIFont(name: "HelveticaNeue-Light", size: 15)!
        let fontMetrics = UIFontMetrics(forTextStyle: .subheadline)

        return fontMetrics.scaledFont(for: font)
    }

    static var cba_helveticaNeueBoldSubhead: UIFont {
        let font = UIFont(name: "HelveticaNeue-Bold", size: 15)!
        let fontMetrics = UIFontMetrics(forTextStyle: .subheadline)

        return fontMetrics.scaledFont(for: font)
    }
}
