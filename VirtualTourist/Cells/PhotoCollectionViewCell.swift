//
//  PhotoCollectionViewCell.swift
//  VirtualTourist
//
//  Created by Paul Forstner on 31.08.19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {

    // MARK: - IBOutlets
    
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - Lazy
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
       
        let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    // MARK: - Life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        
        imageView.backgroundColor = .gray
        imageView.layer.cornerRadius = 10
        imageView.contentMode = .scaleToFill
    }
    
    // MARK: - Configure
    
    public func configure(with item: Photo?) {
        
        guard let url = URL(string: item?.url ?? "") else {
            return
        }
        
        self.imageView.image = nil
        startAnimating()
        _ = NetworkService.downloadImage(from: url) { [weak self] (imageData, error) in
            
            let image = UIImage(data: imageData ?? Data())
            self?.imageView.image = image
            self?.stopAnimating()
        }
    }
    
    // MARK: - Private
    
    private func startAnimating() {
        
        addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
        activityIndicator.startAnimating()
    }
    
    private func stopAnimating() {
        
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }
}
