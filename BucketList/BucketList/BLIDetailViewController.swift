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
    
    
    var itemCompleted: Bool {
        if let completed = item?.completed {
            if completed {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
        
    }
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var noteTextField: UITextField!
    @IBOutlet weak var completedButton: UIButton!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var saveChangesButton: UIButton!
    @IBOutlet weak var deleteItemButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nameTextField.isUserInteractionEnabled = false
        noteTextField.isUserInteractionEnabled = false
        
        saveChangesButton.isHidden = true
        saveChangesButton.isUserInteractionEnabled = false
        deleteItemButton.isHidden = true
        deleteItemButton.isUserInteractionEnabled = false
    }
    
    @IBAction func editTapped(_ sender: UIBarButtonItem) {
        nameTextField.isUserInteractionEnabled = true
        noteTextField.isUserInteractionEnabled = true
        
        saveChangesButton.isHidden = false
        saveChangesButton.isUserInteractionEnabled = true
        deleteItemButton.isHidden = false
        deleteItemButton.isUserInteractionEnabled = true
    }
    
    @IBAction func completedTapped(_ sender: UIButton) {
        if completedButton.titleLabel?.text == "☑︎ Completed" {
            completedButton.titleLabel?.text = "☐ Completed"
        } else {
            completedButton.titleLabel?.text = "☑︎ Completed"
        }
//        bucketListController?.updateBucketListItem(bucketListItem: item, itemName: item?.itemName, journalEntry: item?.journalEntry, photo: nil, completed: !item?.completed, context: CoreDataStack.shared.mainContext)
        item?.completed.toggle()
    }
    
    @IBAction func saveChangesTapped(_ sender: UIButton) {
        guard let newName = nameTextField.text, !newName.isEmpty, let bucketListController = bucketListController else { return }
        
//        bucketListController.updateBucketListItem(bucketListItem: item, itemName: newName, journalEntry: noteTextField.text, photo: nil, completed: itemCompleted, context: <#T##NSManagedObjectContext#>)
        item?.itemName = newName
        item?.journalEntry = noteTextField.text
    }
    
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
//        bucketListController?.deleteBucketListItem(bucketListItem: item, context: <#T##NSManagedObjectContext#>)
    }
    
    func updateViews() {
        nameTextField.text = item?.itemName
        noteTextField.text = item?.journalEntry
        if item?.completed == true {
            completedButton.titleLabel?.text = "☑︎ Completed"
        } else {
            completedButton.titleLabel?.text = "☐ Completed"
        }
    }
}
