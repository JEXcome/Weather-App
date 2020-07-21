//
//  DetailInteractor.swift
//  Weather App
//
//  Created by (-.-) on 19.07.2020.
//  Copyright © 2020 Eugene Zimin. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

import SwiftyJSON

class DetailInteractor: NSObject
{
    let locality : Locality
    
    let data : Observable<[RichObject]> //= BehaviorRelay<[Locality]>(value: [])
    
    init(locality : Locality)
    {
        self.locality = locality
        
        let forecast = locality.weatherData["daily"].arrayValue
        
        self.data = Observable<[RichObject]>.just(forecast)
        
        
        
        super.init()
    }
}
