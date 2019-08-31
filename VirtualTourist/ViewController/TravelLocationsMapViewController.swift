//
//  TravelLocationsMapViewController.swift
//  VirtualTourist
//
//  Created by Paul Forstner on 26.08.19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class TravelLocationsMapViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var deleteLabel: UILabel!
    @IBOutlet private weak var deleteLabelHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Lazy
    
    private lazy var viewContext: NSManagedObjectContext = {
        return DataController.shared.viewContext
    }()
    
    private lazy var editButton: UIBarButtonItem = {
        return UIBarButtonItem(title: "Edit", style: .done, target: self, action: #selector(activateEditMode))
    }()
    
    // MARK: - Properties
    
    private var fetchedResultsController: NSFetchedResultsController<Pin>?
    private var editMode = false
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupMapView()
        setupFetchedResultsController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupFetchedResultsController()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        fetchedResultsController = nil
    }

    // MARK: - Setup
    
    private func setupUI() {
        
        title = "Virtual Tourist"
        
        navigationItem.rightBarButtonItem = editButton
        
        deleteLabel.tintColor = .white
        deleteLabel.backgroundColor = .red
        deleteLabelHeightConstraint.constant = 0
    }
    
    private func setupMapView() {
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(addAnnotation(gestureRecognizer:)))
        mapView.addGestureRecognizer(longPress)
        mapView.delegate = self
    }
    
    private func setupFetchedResultsController() {
        
        let fetchRequest: NSFetchRequest<Pin> = Pin.fetchRequest()
        fetchRequest.sortDescriptors = []
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: viewContext, sectionNameKeyPath: nil, cacheName: "pins")
        fetchedResultsController?.delegate = self
        do {
            try fetchedResultsController?.performFetch()
            addPinsToMap()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }

    // MARK: - Private
    
    @objc private func activateEditMode() {
        
        editMode = !editMode
        editButton.title = editMode ? "Done" : "Edit"
        UIView.animate(withDuration: 0.3, animations: {
            self.deleteLabelHeightConstraint.constant = self.editMode ? 60 : 0
            self.view.layoutIfNeeded()
        })
    }
    
    @objc private func addAnnotation(gestureRecognizer: UIGestureRecognizer) {
        
        guard editMode == false else {
            return
        }
        
        let pinLocation = gestureRecognizer.location(in: mapView)
        let pinCoordinate = mapView.convert(pinLocation, toCoordinateFrom: mapView)
        
        addPinToViewContext(with: pinCoordinate)
    }
    
    private func addAnnotation(with coordinate: CLLocationCoordinate2D) {
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
    }
    
    private func addPinToViewContext(with coordinate: CLLocationCoordinate2D) {
        
        let pin = Pin(context: viewContext)
        pin.latitude = coordinate.latitude
        pin.longitude = coordinate.longitude
        try? viewContext.save()
    }
    
    private func addPinsToMap() {
        
        guard let pins = fetchedResultsController?.fetchedObjects else {
            return
        }
        
        mapView.removeAnnotations(mapView.annotations)
        for pin in pins {
            addAnnotation(with: pin.coordinate)
        }
    }
    
    private func didSelect(_ pin: Pin, with view: MKAnnotationView) {

        if editMode {
            
            viewContext.delete(pin)
            try? viewContext.save()
            guard let annotation = view.annotation else {
                return
            }
            mapView.removeAnnotation(annotation)
        } else {
            
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: Constants.ViewControllerIdentifier.photoAlbum) as? PhotoAlbumViewController else {
                return
            }
            
            vc.pin = pin
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension TravelLocationsMapViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        guard type == .insert, let indexPath = newIndexPath,
            let pin = fetchedResultsController?.object(at: indexPath) else {
                return
        }
        
        addAnnotation(with: pin.coordinate)
    }
}

// MARK: - MKMapViewDelegate

extension TravelLocationsMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        guard let pins = fetchedResultsController?.fetchedObjects else {
            return
        }
        
        for pin in pins {
            
            guard let viewCoordinate = view.annotation?.coordinate,
                viewCoordinate.latitude == pin.latitude, viewCoordinate.longitude == pin.longitude else {
                    continue
            }
            
            self.didSelect(pin, with: view)
            break
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "PinAnnotation"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.pinTintColor = .red
        } else {
            pinView?.annotation = annotation
        }
        
        return pinView
    }
}
