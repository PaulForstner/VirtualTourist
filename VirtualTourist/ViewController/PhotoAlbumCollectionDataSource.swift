//
//  PhotoAlbumCollectionDataSource.swift
//  VirtualTourist
//
//  Created by Paul Forstner on 28.08.19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

class PhotoAlbumCollectionDataSource: NSObject {
    
    // MARK: - Typealias
    
    typealias ModelType = Photo
    typealias DidSelectHandler = (_ studentLocation: ModelType, _ indexPath: IndexPath) -> Void
    
    // MARK: - Properties - Handler
    
    private var didSelectHandler: DidSelectHandler
    
    // MARK: - Properties
    
    private var dataSource = [ModelType]()
    
    // MAKR: - Public
    
    func configure(collectionView: UICollectionView) {
        
        collectionView.register(UINib(nibName: Constants.CellIdentifier.photo, bundle: nil), forCellWithReuseIdentifier: Constants.CellIdentifier.photo)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func set(dataSource: [ModelType]) {
        self.dataSource = dataSource
    }
    
    func clear() {
        self.dataSource.removeAll()
    }
    
    // MARK: - Initializer
    
    init(didSelect: @escaping DidSelectHandler) {
        didSelectHandler = didSelect
    }
}

// MARK: - UITableViewDataSource

extension PhotoAlbumCollectionDataSource: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CellIdentifier.photo, for: indexPath) as? PhotoCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: dataSource.item(at: indexPath.row))
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension PhotoAlbumCollectionDataSource: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let item = dataSource.item(at: indexPath.row) else {
            return
        }
        didSelectHandler(item, indexPath)
    }
}
