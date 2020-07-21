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

class MainCell: UICollectionViewCell
{
    @IBOutlet weak var imageView : UIImageView!
    @IBOutlet weak var nameLabel : UILabel!
    @IBOutlet weak var tempLabel : UILabel!
    @IBOutlet weak var descLabel : UILabel!
    
    func setup(with locality: Locality)
    {
        let url = URL(string: "https://openweathermap.org/img/wn/" + locality.weatherData["current"]["weather"][0]["icon"].stringValue + "@2x.png")!
        let processor = RoundCornerImageProcessor(cornerRadius: 20)
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(
            with: url,
            options: [
                .processor(processor),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        
        nameLabel.text = locality.name
        tempLabel.text = String(format:"%+.1f",locality.weatherData["current"]["temp"].floatValue) + " °C"
        descLabel.text = locality.weatherData["current"]["weather"][0]["description"].stringValue.firstCapitalized
        
        layer.borderWidth = 1 / UIScreen.main.nativeScale
        layer.borderColor = UIColor.gray.cgColor
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes
    {
        return layoutAttributes
    }
    
}
