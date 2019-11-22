//
//  BucketListItemViewController.swift
//  BucketList
//
//  Created by Gi Pyo Kim on 11/18/19.
//  Copyright © 2019 GIPGIP Studio. All rights reserved.
//

import UIKit
import CoreData

class BucketListItemViewController: UIViewController {
    
    var bucketListController: BucketListController?
    
    var blockOperations: [BlockOperation] = []
    
    var shouldReloadCollectionView: Bool = false
    
    var bucketList: BucketList? {
        didSet {
            self.title = bucketList?.name
        }
    }
    
    lazy var fetchedResultsController: NSFetchedResultsController<BucketListItem> = {
        
        let fetchRequest: NSFetchRequest<BucketListItem> = BucketListItem.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "itemName", ascending: true)
        ]
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.shared.mainContext, sectionNameKeyPath: "itemName", cacheName: nil)
        
        frc.delegate = self
        
        do {
            try frc.performFetch()
        } catch {
            fatalError("Error performing fetch for frc: \(error)")
        }
        return frc
    }()
    
    var items: [BucketListItem] = []
    var selectedItem: BucketListItem?
    
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    
    deinit {
        for operation: BlockOperation in blockOperations {
            operation.cancel()
        }
        blockOperations.removeAll(keepingCapacity: false)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "CreateBLISegue" {
            if let createVC = segue.destination as? CreateBucketListItemViewController {
                createVC.bucketListController = bucketListController
                createVC.bucketList = bucketList
            }
        } else if segue.identifier == "EditInfoSegue" {
            if let infoVC = segue.destination as? CreateBucketListViewController {
                infoVC.bucketListController = bucketListController
//                infoVC.bucketList = bucketList
            }
        } else if segue.identifier == "ItemDetailSegue" {
            if let createVC = segue.destination as? BLIDetailViewController {
                createVC.bucketListController = bucketListController
                createVC.bucketList = bucketList
                createVC.item = selectedItem
            }
        }
    }
}

extension BucketListItemViewController: UICollectionViewDataSource, NSFetchedResultsControllerDelegate {
        
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        fetchedResultsController.sections?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath) as? BucketListItemCollectionViewCell else { return UICollectionViewCell()}
        
        cell.item = fetchedResultsController.object(at: indexPath)
        
        return cell
    }
}

extension BucketListItemViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedItem = items[indexPath.item]
        performSegue(withIdentifier: "ItemDetailSegue", sender: collectionView.cellForItem(at: indexPath))
       }
}
