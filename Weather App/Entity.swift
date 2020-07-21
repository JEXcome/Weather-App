//
//  Data.swift
//  Weather App
//
//  Created by (-.-) on 18.07.2020.
//  Copyright © 2020 Eugene Zimin. All rights reserved.
//

import Foundation

import CoreLocation

import RxSwift
import RxCocoa

import SwiftyJSON


class Entity : NSObject
{
    var data : BehaviorRelay<[Locality]> = BehaviorRelay<[Locality]>(value: [])
    
    func appendLocality(_ locality : Locality)
    {
        data.accept(data.value + [locality])
    }
    
    func prependLocality(_ locality : Locality)
    {
        data.accept([locality] + data.value)
    }
    
    func removeLocality(at index: Int)
    {
        var temp = data.value
        
        temp.remove(at: index)
        
        data.accept(temp)
    }
}


class Locality: NSObject, Codable
{
    var coordinate : CLLocationCoordinate2D
    var name : String
    var weatherData : RichObject
    
    enum CodingKeys: CodingKey
    {
        case coordinate
        case name
        case weatherData
    }
    
    init(coordinate : CLLocationCoordinate2D, name: String = "", weatherData: RichObject = .null)
    {
        self.coordinate = coordinate
        self.name = name
        self.weatherData = weatherData
        
        super.init()
    }
    
    required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
    
        coordinate = try container.decode(CLLocationCoordinate2D.self, forKey: .coordinate)
        name = try container.decode(String.self, forKey: .name)
        weatherData = try container.decode(RichObject.self, forKey: .weatherData)
    }
}

extension CLLocationCoordinate2D: Codable
{
    public init(from decoder: Decoder) throws
    {
        let representation = try decoder.singleValueContainer().decode([String: CLLocationDegrees].self)
        self.init(latitude: representation["latitude"] ?? 0, longitude:  representation["longitude"] ?? 0)
    }

    public func encode(to encoder: Encoder) throws
    {
        let representation = ["latitude": self.latitude, "longitude": self.longitude]
        try representation.encode(to: encoder)
    }
}

extension CLLocationCoordinate2D : Equatable
{
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool
    {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
