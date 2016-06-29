//
//  HomeViewController.swift
//  GoGoGitHub
//
//  Created by Olesia Kalashnik on 6/28/16.
//  Copyright © 2016 Olesia Kalashnik. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UIViewControllerTransitioningDelegate, Setup  {
    @IBOutlet weak var tableView: UITableView!
    
    var repositories = [Repository]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    lazy var transition = CustomModalTransition(duration: 1.0)
    
    lazy var refreshControl = UIRefreshControl()
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transition
    }
    
    func setup() {
        self.title = "Repositories"
    }
    func setupAppearance() {
        self.refreshControl.addTarget(self, action: #selector(HomeViewController.update), forControlEvents: UIControlEvents.AllEvents)
        self.tableView.addSubview(refreshControl)
    }
    
    func update() {
        API.shared.GETRepositories({ (repos) in
            if let data = repos {
                self.repositories = data
            }
        })
        if self.refreshControl.refreshing {
            self.refreshControl.endRefreshing()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.update()
        self.setup()
        self.setupAppearance()
    }
    
}

extension HomeViewController : UITableViewDataSource, ProfileViewControllerDelegate {
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == ProfileViewController.id {
            if let profileVC = segue.destinationViewController as? ProfileViewController {
                profileVC.delegate = self
                profileVC.transitioningDelegate = self
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RepositoryCell", forIndexPath: indexPath)
        cell.textLabel?.text = repositories[indexPath.row].name
        let date = String(repositories[indexPath.row].createdAt)
        cell.detailTextLabel?.text = date.substringToIndex(date.startIndex.advancedBy(10))
        return cell
    }
    
    //MARK: ProfileViewControllerDelegate Methods
    func profileVCDidFinish() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func addRepository(sender: UIBarButtonItem) {
        let controller = UIAlertController(title: "Create", message: "Please enter repository name", preferredStyle: .Alert)
        let createAction = UIAlertAction(title: "Create", style: .Default) { (action) in
            guard let textField = controller.textFields?.first else { return }
            if let text = textField.text {
                API.shared.POSTRepository(text, completion: { (success) in
                    print("Repository created")
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
