//
//  MockLocation.swift
//  CBATests
//
//  Created by Aravind R on 18/09/21.
//

@testable import CBA

extension Location {
    static func makeMock() -> Location {
        Location(latitude: 33.8568, longitude: 151.2153)
    }
}
