//
//  HomeViewController.swift
//  GoGoGitHub
//
//  Created by Sean Champagne on 6/28/16.
//  Copyright © 2016 Sean Champagne. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    
    var repositories = [Repository]()
        {
        didSet {
            self.tableview.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        API.shared.GETRepositories { (repositories) in
//            if let data = repositories {
//                self.repositories = data
//            }
//        }
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
//        API.shared.GETRepositories { (repositories) in
//            if let data = repositories {
//                self.repositories = data
//            }
//            }
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        API.shared.GETRepositories { (repositories) in
            if let data = repositories {
                self.repositories = data
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
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
