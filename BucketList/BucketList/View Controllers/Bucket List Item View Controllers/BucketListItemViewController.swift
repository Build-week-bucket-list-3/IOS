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
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.shared.mainContext, sectionNameKeyPath: nil, cacheName: nil)
        
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
    
    
    
   func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
          
          if type == NSFetchedResultsChangeType.insert {
              print("Insert Object: \(newIndexPath)")
              
              if (collectionView?.numberOfSections)! > 0 {
                  
                  if collectionView?.numberOfItems( inSection: newIndexPath!.section ) == 0 {
                    self.shouldReloadCollectionView = true
                  } else {
                      blockOperations.append(
                          BlockOperation(block: { [weak self] in
                              if let this = self {
                                  DispatchQueue.main.async {
                                      this.collectionView!.insertItems(at: [newIndexPath!])
                                  }
                              }
                              })
                      )
                  }
                  
              } else {
                  self.shouldReloadCollectionView = true
              }
          }
          else if type == NSFetchedResultsChangeType.update {
              print("Update Object: \(indexPath)")
              blockOperations.append(
                  BlockOperation(block: { [weak self] in
                      if let this = self {
                          DispatchQueue.main.async {
                              
                              this.collectionView!.reloadItems(at: [indexPath!])
                          }
                      }
                      })
              )
          }
          else if type == NSFetchedResultsChangeType.move {
              print("Move Object: \(indexPath)")
              
              blockOperations.append(
                  BlockOperation(block: { [weak self] in
                      if let this = self {
                          DispatchQueue.main.async {
                              this.collectionView!.moveItem(at: indexPath!, to: newIndexPath!)
                          }
                      }
                      })
              )
          }
          else if type == NSFetchedResultsChangeType.delete {
              print("Delete Object: \(indexPath)")
              if collectionView?.numberOfItems( inSection: indexPath!.section ) == 1 {
                  self.shouldReloadCollectionView = true
              } else {
                  blockOperations.append(
                      BlockOperation(block: { [weak self] in
                          if let this = self {
                              DispatchQueue.main.async {
                                  this.collectionView!.deleteItems(at: [indexPath!])
                              }
                          }
                          })
                  )
              }
          }
      }
    
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        if type == NSFetchedResultsChangeType.insert {
            print("Insert Section: \(sectionIndex)")
            blockOperations.append(
                BlockOperation(block: { [weak self] in
                    if let this = self {
                        DispatchQueue.main.async {
                            this.collectionView!.insertSections(NSIndexSet(index: sectionIndex) as IndexSet)
                        }
                    }
                    })
            )
        }
        else if type == NSFetchedResultsChangeType.update {
            print("Update Section: \(sectionIndex)")
            blockOperations.append(
                BlockOperation(block: { [weak self] in
                    if let this = self {
                        DispatchQueue.main.async {
                            this.collectionView!.reloadSections(NSIndexSet(index: sectionIndex) as IndexSet)
                        }
                    }
                    })
            )
        }
        else if type == NSFetchedResultsChangeType.delete {
            print("Delete Section: \(sectionIndex)")
            blockOperations.append(
                BlockOperation(block: { [weak self] in
                    if let this = self {
                        DispatchQueue.main.async {
                            this.collectionView!.deleteSections(NSIndexSet(index: sectionIndex) as IndexSet)
                        }
                    }
                    })
            )
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        if (self.shouldReloadCollectionView) {
            DispatchQueue.main.async {
                self.collectionView.reloadData();
            }
        } else {
            DispatchQueue.main.async {
                self.collectionView!.performBatchUpdates({ () -> Void in
                    for operation: BlockOperation in self.blockOperations {
                        operation.start()
                    }
                    }, completion: { (finished) -> Void in
                        self.blockOperations.removeAll(keepingCapacity: false)
                })
            }
        }
    }
    
    
    
    
}

extension BucketListItemViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: Need to delete items array and fetch from core data
//        self.selectedItem = items[indexPath.item]
//        performSegue(withIdentifier: "ItemDetailSegue", sender: collectionView.cellForItem(at: indexPath))
       }
}
