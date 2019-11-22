//
//  CreateBucketListItemViewController.swift
//  BucketList
//
//  Created by Gi Pyo Kim on 11/18/19.
//  Copyright © 2019 GIPGIP Studio. All rights reserved.
//

import UIKit

class CreateBucketListItemViewController: UIViewController {
    
    var bucketListController: BucketListController?
    var bucketList: BucketList?
    
    @IBOutlet weak var itemNameTextField: UITextField!
    @IBOutlet weak var noteTextField: UITextField!
    @IBOutlet weak var itemImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func addPhotoButtonTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func createButtonTapped(_ sender: UIButton) {
        guard let name = itemNameTextField.text, !name.isEmpty, let bucketList = bucketList, let bucketListController = bucketListController else { return }
        
        // Need to upload the image to Cloudinary and get URL back
//        let imageString: String?
//        if let image = itemImageView.image {
//            if let data = image.pngData() {
//               let url = URL(dataRepresentation: data, relativeTo: <#T##URL?#>)
//            }
//
//        }
            
        bucketListController.createBucketListItem(bucketList: bucketList, itemName: name, journalEntry: noteTextField.text, photo: nil)
        navigationController?.popViewController(animated: true)
    }
}
