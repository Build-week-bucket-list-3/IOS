//
//  BucketListItemViewController.swift
//  BucketList
//
//  Created by Gi Pyo Kim on 11/18/19.
//  Copyright © 2019 GIPGIP Studio. All rights reserved.
//

import UIKit

class BucketListItemViewController: UIViewController {
    
    var bucketListController: BucketListController?
    
    var bucketList: BucketList? {
        didSet {
            // fetchitems()
            self.title = bucketList?.name
        }
    }
    
    var items: [BucketListItem] = []
    var selectedItem: BucketListItem?
    
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
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
                infoVC.bucketList = bucketList
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

extension BucketListItemViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath) as? BucketListItemCollectionViewCell else { return UICollectionViewCell()}
        
        cell.item = items[indexPath.item]
        
        return cell
    }
}

extension BucketListItemViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedItem = items[indexPath.item]
        performSegue(withIdentifier: "ItemDetailSegue", sender: collectionView.cellForItem(at: indexPath))
       }
}
