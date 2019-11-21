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
    var item: BucketListItem?

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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func switchJournalMedia(_ sender: Any) {
        
        if journalMediaSegmentedControl.selectedSegmentIndex == 0 {
            journalViewLeadingConstraint.constant = 0
            mediaViewLeadingConstraint.constant = 300
        } else {
            journalViewLeadingConstraint.constant = -300
            mediaViewLeadingConstraint.constant = 0
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
}
