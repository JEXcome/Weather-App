//
//  AppDelegate.swift
//  Weather App
//
//  Created by (-.-) on 16.07.2020.
//  Copyright © 2020 Eugene Zimin. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa


@UIApplicationMain
class WeatherAppDelegate: UIResponder, UIApplicationDelegate
{
    var window: UIWindow?
    
    var navigation : UINavigationController!
    
    static weak var shared : WeatherAppDelegate!
    
    private let entity = Entity()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        navigation = (window!.rootViewController as! UINavigationController)
        
        WeatherAppDelegate.shared = self

        let interactor = MainInteractor(entity: entity)
        let presenter = MainPresenter(interactor: interactor)
        let view = MainViewController.create(presenter: presenter)
        
        navigation.viewControllers = [view]

        return true
    }

}

