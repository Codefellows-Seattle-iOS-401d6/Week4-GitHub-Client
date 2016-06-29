//
//  HomeViewController.swift
//  GoGoGitHub
//
//  Created by Jess Malesh on 6/28/16.
//  Copyright © 2016 Jess Malesh. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UIViewControllerTransitioningDelegate, Setup
{
    
    @IBOutlet weak var tableView: UITableView!
    
    lazy var transition = CustomModelTransition(duration: 0.4)
    
    var repositories = [Repository]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    lazy var refreshControll = UIRefreshControl()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.setup()
        self.setupAppearance()
    }
    
    

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.update()
    }
    
    func update()
    {
        API.shared.GET{ (repositories) in
            if let data = repositories {
                self.repositories = data
            }
        }
        self.refreshControll.endRefreshing()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func setupAppearance() {
    }
    
    func setup()
    {
        self.refreshControll.addTarget(self, action: #selector(HomeViewController.update), forControlEvents: .AllEvents)
            
        self.tableView.addSubview(self.refreshControll)
    }
    
    
    
    @IBAction func plusButtonSelected(sender: AnyObject)
    {
        let controller = UIAlertController(title: "Create", message: "Please enter a name", preferredStyle: .Alert)
        let createAction = UIAlertAction(title: "Create", style: .Default) { (action) in
            
            guard let textField = controller.textFields?.first else { return }
            
            if let text = textField.text {
                API.shared.POSTRepository(text, completion: { (success) in
                    if success {
                        print("Repo created...")
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

extension HomeViewController : UITableViewDataSource, ProfileViewControllerDelegate
{
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == ProfileViewController.id {
            if let profileViewController = segue.destinationViewController as? ProfileViewController {
                profileViewController.delegate = self
                profileViewController.transitioningDelegate = self
            }
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.repositories.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let repositoryCell = tableView.dequeueReusableCellWithIdentifier("repositoryCell", forIndexPath: indexPath)
        let repository = self.repositories[indexPath.row]
        
        repositoryCell.textLabel?.text = repository.name
        return repositoryCell
    }

    func profileViewControllerDidFinish()
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        return self.transition
    }









}















