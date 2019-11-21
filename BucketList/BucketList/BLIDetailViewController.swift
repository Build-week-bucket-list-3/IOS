//
//  BLIDetailViewController.swift
//  BucketList
//
//  Created by Gi Pyo Kim on 11/18/19.
//  Copyright © 2019 GIPGIP Studio. All rights reserved.
//

import UIKit

class BLIDetailViewController: UIViewController {
    
    var bucketListController: BucketListController?
    var bucketList: BucketList?
    var item: BucketListItem?

    @IBOutlet weak var addEntryMediaButton: UIButton!
    @IBOutlet weak var journalMediaSegmentedControl: UISegmentedControl!
    @IBOutlet weak var journalViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var mediaViewLeadingConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.title.text = item?.name

        // Make journal view show by default
        journalMediaSegmentedControl.selectedSegmentIndex = 0
        journalViewLeadingConstraint.constant = 0
        mediaViewLeadingConstraint.constant = 300
        // Do any additional setup after loading the view.
    }
    
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
//           delete item function
       }
    @IBAction func addEntryMediaButtonTapped(_ sender: UIButton) {
        if journalMediaSegmentedControl.selectedSegmentIndex == 0 {
            performSegue(withIdentifier: "AddEntrySegue", sender: addEntryMediaButton)
        } else {
            performSegue(withIdentifier: "AddMediaSegue", sender: addEntryMediaButton)
        }
    }
    
    @IBAction func switchJournalMedia(_ sender: Any) {
        
        if journalMediaSegmentedControl.selectedSegmentIndex == 0 {
            journalViewLeadingConstraint.constant = 0
            mediaViewLeadingConstraint.constant = 300
            addEntryMediaButton.titleLabel?.text = "Add Entry"
        } else {
            journalViewLeadingConstraint.constant = -300
            mediaViewLeadingConstraint.constant = 0
            addEntryMediaButton.titleLabel?.text = "Add Media"

        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    
    // MARK: - Navigation
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "EmbeddedCollectionSegue" {
//            if let collectionVC = segue.destination as? MediaCollectionViewController {
//                collectionVC.bucketListController = bucketListController
//                collectionVC.item = item
//            }
//        } else if segue.identifier == "EmbeddedTableSegue" {
//            if let tableVC = segue.destination as? JournalTableViewController {
//                tableVC.bucketListController = bucketListController
//                tableVC.item = item
//            }
//        } else if segue.identifier == "BLIteminfoSegue" {
//            if let infoVC = segue.destination as? BLinfoViewController {
//                infoVC.bucketListController = bucketListController
//                infoVC.bucketListItem = item
//            }
//        } else if segue.identifier == "AddEntrySegue" {
//            if let entryVC = segue.destination as? CreateBucketListItemViewController {
////                entryVC.bucketListController = bucketListController
//                //                entryVC.item = item also fix downcast ^
//            }
//        } else if segue.identifier == "AddMediaSegue" {
//            if let mediaVC = segue.destination as? BLinfoViewController {
////                mediaVC.bucketListController = bucketListController
////                mediaVC.bucketListItem = item
//                //                tableVC.item = item also fix downcast ^
//
//            }
//        }
//    }
}
