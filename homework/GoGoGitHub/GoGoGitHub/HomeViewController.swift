//
//  HomeViewController.swift
//  GoGoGitHub
//
//  Created by Sung Kim on 6/28/16.
//  Copyright © 2016 Sung Kim. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UIViewControllerTransitioningDelegate {

    var repositories = [Repository]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    lazy var refreshControl = UIRefreshControl()
    
    //Apple's default modal transition is 0.4
    lazy var transition = CustomModalTransition(duration: 0.4)
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.getRepos()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getRepos() {
        API.shared.GETRepositories { (repositories) in
            if let data = repositories {
                self.repositories = data
            }
        }
        if self.refreshControl.refreshing {
            self.refreshControl.endRefreshing()
        }
    }
    
    //allowing add button to Post repositories
    @IBAction func addButtonSelected(sender: AnyObject) {
        let controller = UIAlertController(title: "Create", message: "Please enter a Repository Name", preferredStyle: .Alert)
        let createAction = UIAlertAction(title: "Create", style: .Default) { (action) in
            guard let textField = controller.textFields?.first else { return }
            if let text = textField.text {
                API.shared.POSTRepository(text, completion: { (success) in
                    if success {
                        print("Repo created")
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

extension HomeViewController: Setup {
    func setup() {
        self.navigationItem.title = "Repositories"
        self.refreshControl.addTarget(self, action: #selector(HomeViewController.getRepos), forControlEvents: .AllEvents)
        self.tableView.addSubview(self.refreshControl)
    }
    
    func setupAppearance() {
        
    }
}

extension HomeViewController: UITableViewDataSource, ProfileViewControllerDelegate {
    //this is to provide a pointer to the ProfileViewController using the segue
    
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
    
    //MARK: ProfileViewControllerDelegate
    //this is to dismiss the profileviewcontroller
    func profileViewControllerDidFinish() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: UIVIewControllerTransitionDelegate
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.transition
    }
}