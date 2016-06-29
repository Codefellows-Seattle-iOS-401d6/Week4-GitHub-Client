//
//  API.swift
//  GoGoGitHub
//
//  Created by Olesia Kalashnik on 6/28/16.
//  Copyright © 2016 Olesia Kalashnik. All rights reserved.
//

import Foundation
class API {
    static let shared = API()
    private let session: NSURLSession
    private let template : NSURLComponents
    private init() {
        self.session = NSURLSession(configuration: .defaultSessionConfiguration())
        self.template = NSURLComponents()
        self.configure()
    }
    
    private func configure() {
        self.template.scheme = "https"
        self.template.host = "api.github.com"
        do {
            if let token = try GitHubOAuth.shared.accessToken() {
                self.template.queryItems = [NSURLQueryItem(name: "access_token", value: token)]
            }
        } catch {
            print("Unable to retreive access token")
        }
    }
    
    func GETRepositories(completion: (repos: [Repository]?) ->()) {
        self.template.path = "/user/repos"
        self.session.dataTaskWithURL(self.template.URL!, completionHandler:  { (data, response, error) in
            if let error = error {
                print(error)
            }
            if let safeData = data {
                do {
                    if let json = try NSJSONSerialization.JSONObjectWithData(safeData, options: NSJSONReadingOptions()) as? [[String:AnyObject]] {
                        var repositories = [Repository]()
                        for repositoryJSON in json {
                            if let safeRepositoryJSON = Repository(json: repositoryJSON) {
                                repositories.append(safeRepositoryJSON)
                                print(safeRepositoryJSON)
                            }
                        }
                    }
                } catch {
                    print("Failed in JSON serialization")
                }
            }
        }).resume()
    }
    
}






