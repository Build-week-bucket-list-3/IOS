//
//  BucketListTableViewController.swift
//  BucketList
//
//  Created by Gi Pyo Kim on 11/18/19.
//  Copyright © 2019 GIPGIP Studio. All rights reserved.
//

import UIKit
import CoreData

class BucketListTableViewController: UITableViewController {
    
    // Side Menu
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var createABucketListButton: UIButton!
    var isMenuShowing = false
    let menuHidingConstant: CGFloat = -245
    
    // Controllers
    var bucketListController = BucketListController()
    
    lazy var fetchedResultsController: NSFetchedResultsController<BucketList> = {
        
        let fetchRequest: NSFetchRequest<BucketList> = BucketList.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "name", ascending: true)
        ]
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.shared.mainContext, sectionNameKeyPath: "name", cacheName: nil)
        
        frc.delegate = self
        
        do {
            try frc.performFetch()
        } catch {
            fatalError("Error performing fetch for frc: \(error)")
        }
        return frc
    }()
    
    // MARK: - Segue to Login page
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if bucketListController.bearer == nil {
            performSegue(withIdentifier: "LogInSegue", sender: self)
            
        } else {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // side menu setup
        leadingConstraint.constant = menuHidingConstant
        menuView.layer.shadowOpacity = 1
        menuView.layer.shadowRadius = 5
        
        // Create a Bucket List Button setup
        createABucketListButton.backgroundColor = .clear
        createABucketListButton.layer.cornerRadius = 5
        createABucketListButton.layer.borderWidth = 2
        createABucketListButton.layer.borderColor = CGColor(srgbRed: 2, green: 127, blue: 167, alpha: 1)
        
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        bucketListController.fetchAllBucketListsFromServer { (error) in
            if let error = error {
                NSLog("Error fetching all bucket lists from server: \(error)")
                return
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BucketListCell", for: indexPath) as? BucketListTableViewCell else { return UITableViewCell() }
        
        cell.bucketList = fetchedResultsController.object(at: indexPath)
        
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            bucketListController.deleteBucketList(bucketList: fetchedResultsController.object(at: indexPath), context: CoreDataStack.shared.mainContext)
            
        }
    }
    
    
    
    
    // MARK: - Navigation    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LogInSegue" {
            if let loginVC = segue.destination as? SignInViewController {
            loginVC.bucketListController = bucketListController
            }
        } else if segue.identifier == "CreateBucketListSegue" {
            if let createBLVC = segue.destination as? CreateBucketListViewController {
                createBLVC.bucketListController = bucketListController
            }
        } else if segue.identifier == "BLDetailViewSegue" {
            if let bucketListItemVC = segue.destination as? BucketListItemViewController,
                let indexPath = tableView.indexPathForSelectedRow {
                bucketListItemVC.bucketList = fetchedResultsController.object(at: indexPath)
            }
        }
        
    }
    
    @IBAction func openMenu(_ sender: Any) {
        
        if isMenuShowing {
            leadingConstraint.constant = menuHidingConstant
        } else {
            leadingConstraint.constant = 0
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        isMenuShowing = !isMenuShowing
    }
    
}

extension BucketListTableViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
            
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
            
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
        case .move:
            guard let indexPath = indexPath, let newIndexPath = newIndexPath else { return }
            tableView.moveRow(at: indexPath, to: newIndexPath)
            
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
            
        @unknown default:
            fatalError()
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        let indexSet = IndexSet(integer: sectionIndex)
        
        switch type {
        case .insert:
            tableView.insertSections(indexSet, with: .automatic)
        case .delete:
            tableView.deleteSections(indexSet, with: .automatic)
        default:
            return
        }
        
    }
}
