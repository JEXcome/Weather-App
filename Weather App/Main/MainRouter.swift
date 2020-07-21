//
//  MainRouter.swift
//  Weather App
//
//  Created by (-.-) on 19.07.2020.
//  Copyright © 2020 Eugene Zimin. All rights reserved.
//

import Foundation
import UIKit

class MainRouter: NSObject
{
    func toDetail(_ locality: Locality)
    {
        let interactor = DetailInteractor(locality: locality)
        let presenter = DetailPresenter(interactor: interactor)
        let view = DetailViewController.create(presenter: presenter)
        view.navigationItem.title = locality.name
        
        WeatherAppDelegate.shared.navigation.pushViewController(view, animated: true)
    }
}
