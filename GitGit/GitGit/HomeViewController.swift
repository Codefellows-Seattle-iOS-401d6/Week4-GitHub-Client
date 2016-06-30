//
//  HomeViewController.swift
//  GitGit
//
//  Created by Derek Graham on 6/28/16.
//  Copyright © 2016 Derek Graham. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UIViewControllerTransitioningDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    lazy var transition = CustomModalTransition(duration: 1.5)
    
    var repositories = [Repository]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    var etag: AnyObject? 
    
    lazy var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.setupAppearance()

    }
    // self.refreshControl.addTarger(self, action: #selector(

    
    override func viewWillAppear(animated: Bool) {
   
        super.viewWillAppear(animated)
        self.getRepos()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    func getRepos(){
    
        API.shared.GETRepositories { (repositories, etag) in
            if let data = repositories {
                self.repositories = data
                self.etag = etag
                print("etag in HVC: \(etag)")
            }
        }
    }
    
    @IBAction func addRepoButtonSelected(sender: AnyObject) {
        let controller = UIAlertController(title: "Add Repository", message: "Please enter a name:", preferredStyle: .Alert)
        let createAction = UIAlertAction(title: "Create", style: .Default) { (action) in
            
            guard let textField = controller.textFields?.first else { return }
            if let text = textField.text {
                API.shared.POSTRepository(text, completion: { (success, repository) in
                    if success {
                        print("Repository created...")
//                        print("repository returned\(repository)")
                        self.repositories.insert(repository!, atIndex: 0)
                        
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

extension HomeViewController: Setup, ProfileViewControllerDelegate  {
    
    func setup() {
        self.navigationItem.title = "Repositories"
    }
    
    func setupAppearance() {
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == ProfileViewController.id {
            if let profileViewController = segue.destinationViewController as? ProfileViewController {
                profileViewController.delegate = self
                profileViewController.transitioningDelegate = self
            }
        }
    }
    
    func profileViewControllerDidFinish() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.transition
    }
    
}


extension HomeViewController: UITableViewDataSource
{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.repositories.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let repositoryCell = tableView.dequeueReusableCellWithIdentifier("repositoryCell", forIndexPath: indexPath)
        let repository = self.repositories[indexPath.row]
        repositoryCell.textLabel?.text = repository.name
        return repositoryCell
    }

}