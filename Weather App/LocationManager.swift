//
//  LocationManager.swift
//  Weather App
//
//  Created by (-.-) on 17.07.2020.
//  Copyright © 2020 Eugene Zimin. All rights reserved.
//

import Foundation

import CoreLocation

import RxSwift
import RxCocoa
import RxCoreLocation


public class LocationManager: CLLocationManager //singleton
{
    private static let _shared = LocationManager()
    
    public class var shared : LocationManager
    {
        return _shared
    }
    
    deinit
    {
        stopUpdatingLocation()
    }
    
    private override init()
    {
        super.init()
        
        requestWhenInUseAuthorization()
        
        startUpdatingLocation()
    }
}
