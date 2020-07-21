//
//  MainInteractor.swift
//  Weather App
//
//  Created by (-.-) on 19.07.2020.
//  Copyright © 2020 Eugene Zimin. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

class MainInteractor: NSObject
{
    private let entity : Entity
    
    public var data : BehaviorRelay<[Locality]>
    {
        return entity.data
    }
    
    init(entity:Entity)
    {
        self.entity = entity
        
        super.init()
    }
    
    func appendLocality(_ locality : Locality)
    {
        entity.appendLocality(locality)
    }
    
    func prependLocality(_ locality : Locality)
    {
        entity.prependLocality(locality)
    }
    
    func removeLocality(at index: Int)
    {
        entity.removeLocality(at: index)
    }
    
    func locality(at index: Int) -> Locality
    {
        return entity.data.value[index]
    }
}
