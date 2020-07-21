//
//  MainPresenter.swift
//  Weather App
//
//  Created by (-.-) on 19.07.2020.
//  Copyright © 2020 Eugene Zimin. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa


class MainPresenter: NSObject
{
    public let rxBag = DisposeBag()
    
    private let interactor : MainInteractor
    
    private let router : MainRouter

    init(interactor:MainInteractor)
    {
        self.interactor = interactor
        
        self.router = MainRouter()
        
        super.init()
    }
    
    func addLocality(_ locality : Locality)
    {
        interactor.appendLocality(locality)
    }
    
    func addCurrentLocality()
    {
        guard interactor.data.value.count == 0
        else
        {
            return
        }
        
        Observable.combineLatest(LocationManager.shared.rx.location, LocationManager.shared.rx.placemark)
        {
            return (location:$0,placemark:$1)
            
        }
        .delay(.milliseconds(500), scheduler: MainScheduler.instance)
        .filter
        { (arg0) -> Bool in
            
            let (location, placemark) = arg0
                guard
                 let _ = location,
                 let _ = placemark.addressDictionary?["City"] as? String
            else
            {
                return false
            }
             
            return true
        }
        .take(1)
        .subscribe(onNext:
        { (location,placemark) in
            
            WeatherAPI.shared.weatherForCoordinate(location!.coordinate).subscribe(onNext:
            { (JSON) in
                
                let location = location!
                let name = placemark.addressDictionary!["City"] as! String
                
                let locality = Locality(coordinate: location.coordinate, name: name, weatherData: JSON)
                
                self.interactor.prependLocality(locality)
                
            },
            onError:
            { (error) in
                
                UIAlertController.simpleAlert(title: "Location Service error", message: error.localizedDescription)
                {
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime(uptimeNanoseconds: 5 * 1_000_000_000))
                    {
                        self.addCurrentLocality()
                    }
                }.show(WeatherAppDelegate.shared.navigation, sender: nil)
                    
            }).disposed(by: self.rxBag)
            
        },
        onError:
        { (error) in
            
            UIAlertController.simpleAlert(title: "Weather Service error", message: error.localizedDescription)
            {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime(uptimeNanoseconds: 5 * 1_000_000_000))
                {
                    self.addCurrentLocality()
                }
            }.show(WeatherAppDelegate.shared.navigation, sender: nil)
                
        }).disposed(by: rxBag)
    }
    
    func bindTable(_ vc: MainViewController)
    {
        guard vc.collectionView.dataSource == nil
        else
        {
            return
        }
        
        interactor.data.bind(to: vc.collectionView.rx.items(cellIdentifier: "MainCell", cellType: MainCell.self))
        { index, locality, cell in
            
          cell.setup(with: locality)
        }
        .disposed(by: rxBag)
        
        vc.collectionView.rx.itemSelected.subscribe(onNext:
        { indexPath in
                
            self.router.toDetail(self.interactor.locality(at: indexPath.item))
            
        }).disposed(by: rxBag)
    }
    
    func removeLocality(at index: Int)
    {
        interactor.removeLocality(at: index)
    }
    
    func onViewDidLoad(_ vc: MainViewController)
    {
        vc.collectionView.delegate = nil
        vc.collectionView.dataSource = nil
    }
    
    func onViewAppear(_ vc: MainViewController)
    {
        addCurrentLocality()
        
        bindTable(vc)
    }
}

