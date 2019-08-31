//
//  PhotoAlbumViewController.swift
//  VirtualTourist
//
//  Created by Paul Forstner on 26.08.19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class PhotoAlbumViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    // MARK: - Lazy
    
    private lazy var dataSource: PhotoAlbumCollectionDataSource = {
        return PhotoAlbumCollectionDataSource(didSelect: { [weak self] photo, indexPath in
            self?.removePhoto(photo, at: indexPath)
        })
    }()
    
    // MARK: - Properties
    
    public var pin: Pin?
    private var currentPage = 1
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupMapView()
        dataSource.configure(collectionView: collectionView)
        setDataSource()
    }

    // MARK: - Setup
    
    private func setupMapView() {
        
        mapView.isUserInteractionEnabled = false
        guard let pin = pin else {
            return
        }
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = pin.coordinate
        mapView.addAnnotation(annotation)
        
        let region = MKCoordinateRegion(center: pin.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        
        mapView.setRegion(region, animated: false)
    }
    
    // MARK: - IBActions
    
    @IBAction func createNewCollectionAction(_ sender: Any) {
        loadPhotos()
    }
    
    // MARK: - Private
    
    private func removePhoto(_ photo: Photo, at indexPath: IndexPath) {
        
        DataController.shared.viewContext.delete(photo)
        try? DataController.shared.viewContext.save()
        setDataSource()
        collectionView.performBatchUpdates({
            collectionView.deleteItems(at: [indexPath])
        }, completion: nil)
    }
    
    private func setDataSource() {
        
        guard let photos = pin?.photos?.allObjects as? [Photo], photos.count > 0 else {
            loadPhotos()
            return
        }
        
        dataSource.set(dataSource: photos)
    }
    
    private func loadPhotos() {
        
        guard let pin = pin else {
            return
        }
        
        FlickrNetworkService.search(lat: "\(pin.latitude)", long: "\(pin.longitude)", page: currentPage) { [weak self] result, error in
            
            self?.dataSource.clear()
            
            guard let photos = result?.items else {
                return
            }
            
            if self?.currentPage ?? 0 < result?.pages ?? 0 {
                self?.currentPage += 1
            } else {
                self?.currentPage = 1
            }
            
            for photo in photos {
                
                let _ = Photo(id: photo.id,
                              url: photo.url,
                              pin: pin,
                              context: DataController.shared.viewContext)
            }
            
            try? DataController.shared.viewContext.save()
            self?.setDataSource()
            self?.collectionView.reloadData()
        }
    }
}
