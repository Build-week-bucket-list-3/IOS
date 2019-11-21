//
//  BucketListItemCollectionViewController.swift
//  BucketList
//
//  Created by Gi Pyo Kim on 11/20/19.
//  Copyright © 2019 GIPGIP Studio. All rights reserved.
//

import UIKit

private let reuseIdentifier = "ItemCell"

class BucketListItemCollectionViewController: UICollectionViewController {
    
    var bucketListController: BucketListController?
    
    var bucketList: BucketList?
    
    var items: [BucketListItem]?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return bucketList?.items?.items.count ?? 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? BucketListItemCollectionViewCell else { return UICollectionViewCell() }
        
        let item = bucketList?.items?.items[indexPath.row]
        cell.item = item
        
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ItemDetailSegue" {
            if let indexPath = collectionView.indexPathsForSelectedItems?.first,
                let detailVC = segue.destination as? BLIDetailViewController {
                detailVC.item = bucketList?.items?.items[indexPath.row]
                detailVC.bucketListController = bucketListController
            }
        }
    }
}
