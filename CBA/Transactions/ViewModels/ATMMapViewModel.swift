//
//  ATMMapViewModel.swift
//  CBA
//
//  Created by Aravind R on 18/09/21.
//

import Foundation
import MapKit

struct ATMMapViewModel {
    let atmAnnotation: ATMAnnotation

    init(atmDetail: ATMDetail) {
        atmAnnotation = ATMAnnotation(atmDetail)
    }
}

final class ATMAnnotation: NSObject, MKAnnotation {
    let title: String?
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D

    init(_ atmDetail: ATMDetail) {
        title = atmDetail.name
        subtitle = atmDetail.address
        coordinate = CLLocationCoordinate2D(latitude: atmDetail.location.latitude, longitude: atmDetail.location.longitude)

        super.init()
    }
}
