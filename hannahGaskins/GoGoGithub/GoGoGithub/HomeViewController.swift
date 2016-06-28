//
//  HomeViewController.swift
//  GoGoGithub
//
//  Created by hannah gaskins on 6/28/16.
//  Copyright © 2016 hannah gaskins. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
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
    
    func setup()
    {
        self.refreshControl.addTarget(self, action: #selector(HomeViewController.update), forControlEvents: .AllEvents)
        self.tableView.addSubview(self.refreshControl)
    }
    
    func setupAppearance()
    {
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

}

extension HomeViewController: UITableViewDataSource {
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