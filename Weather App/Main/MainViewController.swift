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

class MainViewController: UICollectionViewController
{
    var _presenter : MainPresenter!
    
    var presenter : MainPresenter! { return _presenter }
    
    static func create(presenter: MainPresenter) -> MainViewController
    {
        let vc = UIStoryboard.init(name: "UI", bundle: nil).instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        
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
        
        let width = collectionView.frame.size.width
        let size = CGSize(width: width, height: (width / 3.2) - 2 )
        
        flowLayout.estimatedItemSize = size
        flowLayout.itemSize = size
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        
        collectionView.setCollectionViewLayout(flowLayout, animated: false)
    }

}

