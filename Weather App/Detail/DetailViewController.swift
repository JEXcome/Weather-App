//
//  MainViewController.swift
//  Weather App
//
//  Created by (-.-) on 16.07.2020.
//  Copyright © 2020 Eugene Zimin. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

import SwiftyJSON
import RxCoreLocation

import DropDown

class DetailViewController: UIViewController
{
    @IBOutlet weak var imageView : UIImageView!
    @IBOutlet weak var nameLabel : UILabel!
    @IBOutlet weak var tempLabel : UILabel!
    @IBOutlet weak var descLabel : UILabel!
    @IBOutlet weak var collectionView : UICollectionView!
    
    var _presenter : DetailPresenter!
    
    var presenter : DetailPresenter! { return _presenter }
    
    static func create(presenter: DetailPresenter) -> DetailViewController
    {
        let vc = UIStoryboard.init(name: "UI", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        
        vc._presenter = presenter
        
        return vc
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        presenter.onViewDidLoad(self)
    }
    

    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        setupLayoutFlow()
        
        presenter.onViewAppear(self)
    }
        
    func setupLayoutFlow()
    {
        super.viewDidLayoutSubviews()
        
        let flowLayout = UICollectionViewFlowLayout()
        
        let height = collectionView.frame.size.height - collectionView.contentInset.bottom
        let size = CGSize(width: height / 2.3, height: height)
        
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        flowLayout.estimatedItemSize = size
        flowLayout.itemSize = size
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        
        collectionView.setCollectionViewLayout(flowLayout, animated: false)
    }

}

