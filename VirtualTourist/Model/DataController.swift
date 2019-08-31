//
//  DataController.swift
//  VirtualTourist
//
//  Created by Paul Forstner on 29.08.19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation
import CoreData

class DataController {
    
    static let shared = DataController()
    
    // MARK: - Lazy
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let persistentContainer = NSPersistentContainer(name: "VirtualTourist")
        return persistentContainer
    }()
    
    // MARK: - Properties
    
    public var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: - Initializer
    
    private init() {}
    
    // MARK: - Private
    
    private func configureContexts() {
        
        viewContext.automaticallyMergesChangesFromParent = true
        viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
    }
    
    // MARK: - Public
    
    public func load() {
        
        persistentContainer.loadPersistentStores { [weak self] storeDescription, error in
            
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            self?.autoSaveViewContext()
            self?.configureContexts()
        }
    }
}

// MARK: - Autosaving

extension DataController {
    
    private func autoSaveViewContext(interval: TimeInterval = 30) {
        
        guard interval > 0 else {
            return
        }
        
        if viewContext.hasChanges {
            try? viewContext.save()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            self.autoSaveViewContext(interval: interval)
        }
    }
}
