//
//  CBAAppUIElement.swift
//  CBAUITests
//
//  Created by Aravind R on 19/09/21.
//

import XCTest

enum CBAAppError: Error {
    case elementDoesNotExist(String)
}

open class CBAUIElement {
    let app: CBAApp
    let element: XCUIElement

    init(app: CBAApp, element: XCUIElement) {
        self.app = app
        self.element = element
    }
}
