//
//  UIColor+CBA.swift
//  CBA
//
//  Created by Aravind R on 18/09/21.
//

import UIKit

extension UIColor {
    
    // MARK: Background colors

    static var cba_greenBackground: UIColor {
        return UIColor { (traits) -> UIColor in
            return traits.userInterfaceStyle == .dark ?
                UIColor(red: 140.0/255.0, green: 165.0/255.0, blue: 166.0/255.0, alpha: 1) :
                UIColor(red: 140.0/255.0, green: 165.0/255.0, blue: 166.0/255.0, alpha: 1)
        }
    }

    static var cba_yellowBackground: UIColor {
        return UIColor { (traits) -> UIColor in
            return traits.userInterfaceStyle == .dark ?
                UIColor(red: 255.0/255.0, green: 204.0/255.0, blue: 0.0/255.0, alpha: 1) :
                UIColor(red: 255.0/255.0, green: 204.0/255.0, blue:  0.0/255.0, alpha: 1)
        }
    }

    static var cba_greyBackground: UIColor {
        return UIColor { (traits) -> UIColor in
            return traits.userInterfaceStyle == .dark ?
                .secondarySystemBackground :
                UIColor(red: 246.0/255.0, green: 246.0/255.0, blue:  246.0/255.0, alpha: 1)
        }
    }
    
    static var cba_whiteBackground: UIColor {
        return .systemBackground
    }
    
    // MARK: Label / Text Colors
    
    static var cba_primaryLabel: UIColor {
        return UIColor { (traits) -> UIColor in
            return traits.userInterfaceStyle == .dark ?
                .label :
                UIColor(red: 35.0/255.0, green: 31.0/255.0, blue: 32.0/255.0, alpha: 1)
        }
    }

    static var cba_secondaryLabel: UIColor {
        return UIColor { (traits) -> UIColor in
            return traits.userInterfaceStyle == .dark ?
                .secondaryLabel :
                UIColor(red: 138.0/255.0, green: 138.0/255.0, blue: 138.0/255.0, alpha: 1)
        }
    }

    // MARK: Separator Colors

    static var cba_separator: UIColor {
        return systemGray5
    }
}
