//
//  CreateBucketListViewController.swift
//  BucketList
//
//  Created by Gi Pyo Kim on 11/18/19.
//  Copyright © 2019 GIPGIP Studio. All rights reserved.
//

import UIKit

class CreateBucketListViewController: UIViewController {
    @IBOutlet weak var nameTextFIeld: UITextField!
    @IBOutlet weak var shareableSegementedControl: UISegmentedControl!
    
    var bucketListController: BucketListController?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func createNewBucketList(_ sender: Any) {
        guard let name = nameTextFIeld.text, !name.isEmpty,
            let bucketListController = bucketListController else { return }
        
        var shareable: Bool!
        switch shareableSegementedControl.selectedSegmentIndex {
        case 0:
            shareable = false
        default:
            shareable = true
        }
        
        bucketListController.createBucketList(name: name, shareable: shareable, context: CoreDataStack.shared.mainContext)
        
        navigationController?.popViewController(animated: true)
    }
}
