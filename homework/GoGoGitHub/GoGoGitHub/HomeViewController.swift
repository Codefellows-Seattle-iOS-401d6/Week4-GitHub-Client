//
//  HomeViewController.swift
//  GoGoGitHub
//
//  Created by Sung Kim on 6/28/16.
//  Copyright © 2016 Sung Kim. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    var repositories = [Repository]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
                print(data)
                self.repositories = data
            }
        }
    }

}

extension HomeViewController: Setup {
    func setup() {
        self.title = "Repositories"
    }
    
    func setupAppearance() {
        
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