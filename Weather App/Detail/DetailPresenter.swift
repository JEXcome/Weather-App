//
//  DetailPresenter.swift
//  Weather App
//
//  Created by (-.-) on 19.07.2020.
//  Copyright © 2020 Eugene Zimin. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

import Kingfisher

class DetailPresenter: NSObject
{
    public let rxBag = DisposeBag()
    
    private let interactor : DetailInteractor
    
    private let router : DetailRouter
    
    init(interactor:DetailInteractor)
    {
        self.interactor = interactor
        
        self.router = DetailRouter()
        
        super.init()
    }
    
    func onSelection(_ vc: DetailViewController,_ indexPath:IndexPath)
    {
        let weatherData = self.interactor.locality.weatherData["daily"].arrayValue[indexPath.item]
        
        let url = URL(string: "https://openweathermap.org/img/wn/" + weatherData["weather"][0]["icon"].stringValue + "@2x.png")!
        let processor = RoundCornerImageProcessor(cornerRadius: 20)
        vc.imageView.kf.indicatorType = .activity
        vc.imageView.kf.setImage(
            with: url,
            options: [
                .processor(processor),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        
        let day = DateFormatter().weekdaySymbols[Calendar.current.component(.weekday, from: Calendar.current.date(byAdding: .day, value: indexPath.item + 1, to: Date())!) - 1].firstCapitalized
        
        vc.nameLabel.text = day
        vc.tempLabel.text = String(format:"%+.f..%+.f",weatherData["temp"]["min"].floatValue, weatherData["temp"]["max"].floatValue) + " °C"
        vc.descLabel.text = weatherData["weather"][0]["description"].stringValue.firstCapitalized
    }
    
    func bindTable(_ vc: DetailViewController)
    {

        guard vc.collectionView.dataSource == nil
        else
        {
            return
        }
        
        interactor.data.bind(to: vc.collectionView.rx.items(cellIdentifier: "DetailCell", cellType: DetailCell.self))
        { index, weatherData, cell in
          cell.setup(with: weatherData, index: index)
        }
        .disposed(by: rxBag)
        
        vc.collectionView.rx.itemSelected.subscribe(onNext:
        { indexPath in
            
            self.onSelection(vc, indexPath)
            
        }).disposed(by: rxBag)
        
        #warning("Not solved initial selection reactive way :(")
    }
    
    func onViewDidLoad(_ vc: DetailViewController)
    {
        vc.collectionView.delegate = nil
        vc.collectionView.dataSource = nil
        
        vc.collectionView.layer.borderWidth = 1 / UIScreen.main.nativeScale
        vc.collectionView.layer.borderColor = UIColor.gray.cgColor
        
        vc.imageView.superview?.isHidden = true
        self.onSelection(vc, IndexPath(item: 0, section: 0))
        vc.imageView.superview?.isHidden = false
    }
    
    func onViewAppear(_ vc: DetailViewController)
    {
        bindTable(vc)
    }
    
}
