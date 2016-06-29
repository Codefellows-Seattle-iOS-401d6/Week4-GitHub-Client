//
//  HomeViewController.swift
//  GoGoGithub
//
//  Created by hannah gaskins on 6/28/16.
//  Copyright © 2016 hannah gaskins. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, Setup, UIViewControllerTransitioningDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    // creating instance of our custom animation and duration of 2 seconds here -->
    lazy var transition = CustomModalTransition(duration: 2.0)
    
    var repositories = [Repository]() {
        didSet {
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }

    lazy var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.setupAppearance()
        
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        self.update()
    }
    
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setup() {
        
        self.navigationItem.title = "Repositories"
        self.refreshControl.addTarget(self, action: #selector(HomeViewController.update), forControlEvents: .AllEvents)
        self.tableView.addSubview(self.refreshControl)
    }
    
    func setupAppearance() {
        //
    }
    
    func update()
    {
        API.shared.GETRepositories { (repositories) in
            if let repositories = repositories {
                self.repositories = repositories
            }
        }
    }
    @IBAction func addButtonSelected(sender: AnyObject) {
        let controller = UIAlertController(title: "Create", message: "Please enter a name", preferredStyle: .Alert)
        let createAction = UIAlertAction(title: "Create", style: .Default) { (action) in
            
            // ask controller for text fields
            guard let textField = controller.textFields?.first else { return }
            
            if let text = textField.text {
                API.shared.POSTRepository(text, completion: { (success) in
                    if success {
                        print("repo created...")
                    }
                })
            }
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        
        controller.addTextFieldWithConfigurationHandler(nil)
        controller.addAction(createAction)
        controller.addAction(cancelAction)
        
        self.presentViewController(controller, animated: true, completion: nil)
    }

}



extension HomeViewController: UITableViewDataSource, ProfileViewControllerDelegate {
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == ProfileViewController.id {
            if let profileViewController = segue.destinationViewController as? ProfileViewController {
                profileViewController.delegate = self
                profileViewController.transitioningDelegate = self
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.repositories.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let repositoryCell = tableView.dequeueReusableCellWithIdentifier("repositoryCell", forIndexPath: indexPath)
        let repository = self.repositories[indexPath.row]
        
        repositoryCell.textLabel?.text = repository.name
        return repositoryCell
    }
    
    
    // MARK: ProfileViewControllerDelegate
    
    func profileViewControllerDidFinish() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.transition
    }

}





