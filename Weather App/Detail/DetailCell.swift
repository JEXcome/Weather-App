//
//  MainCell.swift
//  Weather App
//
//  Created by (-.-) on 20.07.2020.
//  Copyright © 2020 Eugene Zimin. All rights reserved.
//

import Foundation
import UIKit

import Kingfisher

import SwiftyJSON

class DetailCell: UICollectionViewCell
{
    @IBOutlet weak var imageView : UIImageView!
    @IBOutlet weak var nameLabel : UILabel!
    @IBOutlet weak var tempLabel : UILabel! 
    @IBOutlet weak var descLabel : UILabel!
    
    func setup(with weatherData: RichObject, index: Int)
    {
        let url = URL(string: "https://openweathermap.org/img/wn/" + weatherData["weather"][0]["icon"].stringValue + "@2x.png")!
        let processor = RoundCornerImageProcessor(cornerRadius: 20)
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(
            with: url,
            options: [
                .processor(processor),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        
        let day = DateFormatter().weekdaySymbols[Calendar.current.component(.weekday, from: Calendar.current.date(byAdding: .day, value: index + 1, to: Date())!) - 1].firstCapitalized
        
        nameLabel.text = day
        tempLabel.text = String(format:"%+.1f..%+.1f",weatherData["temp"]["min"].floatValue, weatherData["temp"]["max"].floatValue) + " °C"
        descLabel.text = weatherData["weather"][0]["description"].stringValue.firstCapitalized
        
        layer.borderWidth = 1 / UIScreen.main.nativeScale
        layer.borderColor = UIColor.gray.cgColor
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes
    {
        return layoutAttributes
    }
    
}
