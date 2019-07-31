//
//  Restaurant.swift
//  FrankieAndBennys
//
//  Created by Yogesh N Ramsorrrun on 27/07/2019.
//  Copyright © 2019 Yogesh N Ramsorrrun. All rights reserved.
//

import Foundation
import MapKit

class Restaurant: NSObject, MKAnnotation, Decodable {
    let title: String?
    let body: String
    let coordinate: CLLocationCoordinate2D
    let url: URL?
    
    init(title: String?, body: String, latitude: Double, longitude: Double, url: String?) {
        self.title = title
        self.body = body
        if let lat = CLLocationDegrees(exactly: latitude),
            let long = CLLocationDegrees(exactly: longitude) {
             self.coordinate = CLLocationCoordinate2DMake(lat, long)
        } else {
            self.coordinate = CLLocationCoordinate2D()
        }
       
        self.url =  url == nil ? nil : URL(string: url!)
    }
    
    enum CodingKeys: String, CodingKey {
        case title = "name"
        case body = "body"
        case latitude = "latitude"
        case longitude = "longitude"
        case url = "url"
    }
    
    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let title: String? = try container.decode(String.self, forKey: .title)
        let body: String = try container.decode(String.self, forKey: .body)
        let latitude: Double = Double(try container.decode(String.self, forKey: .latitude)) ?? 0
        let longitude: Double = Double(try container.decode(String.self, forKey: .longitude)) ?? 0
        let url: String? = try container.decode(String.self, forKey: .url)
        
        self.init(title: title, body: body, latitude: latitude, longitude: longitude, url: url)
    }
}
