//
//  ATMMapViewModelTests.swift
//  CBATests
//
//  Created by Aravind R on 18/09/21.
//

@testable import CBA
import XCTest

final class ATMMapViewModelTests: XCTestCase {

    private var mockATMDetail: ATMDetail!
    private var viewModel: ATMMapViewModel!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        let location = Location(latitude: 33.8568, longitude: 151.2153)
        mockATMDetail = ATMDetail(id: "ATM123",
                                  name: "Darling Harbour ATM",
                                  address: "77 kent street, NSW, 2000",
                                  location: location)
        viewModel = ATMMapViewModel(atmDetail: mockATMDetail)
    }

    override func tearDownWithError() throws {
        mockATMDetail = nil
        viewModel = nil
        
        try super.tearDownWithError()
    }

    func testATMAnnotation() {
        let atmAnnotation = viewModel.atmAnnotation
        
        XCTAssertEqual(atmAnnotation.title, "Darling Harbour ATM")
        XCTAssertEqual(atmAnnotation.subtitle, "77 kent street, NSW, 2000")
        XCTAssertEqual(atmAnnotation.coordinate.latitude, 33.8568)
        XCTAssertEqual(atmAnnotation.coordinate.longitude, 151.2153)
    }
}
