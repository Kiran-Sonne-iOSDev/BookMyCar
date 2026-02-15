//
//  LocationSearchService.swift
//  BookMyCar
//
//  Created by Kiran Sonne on 12/02/26.
//

import MapKit
import Combine

protocol LocationSearchServiceProtocol {
    func search(query: String, region: MKCoordinateRegion) -> AnyPublisher<[MKMapItem], Never>
}

class LocationSearchService: LocationSearchServiceProtocol {
    
    func search(query: String,
                region: MKCoordinateRegion) -> AnyPublisher<[MKMapItem], Never> {
        
        guard !query.isEmpty else {
            return Just([]).eraseToAnyPublisher()
        }
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.region = region
        
        return Future { promise in
            MKLocalSearch(request: request).start { response, _ in
                promise(.success(response?.mapItems ?? []))
            }
        }
        .eraseToAnyPublisher()
    }
}
    