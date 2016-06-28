//
//  API.swift
//  GitGit
//
//  Created by Derek Graham on 6/28/16.
//  Copyright © 2016 Derek Graham. All rights reserved.
//

import Foundation


class API
{
    
    static let shared = API()
    
    private let session: NSURLSession
    
    private let template: NSURLComponents
    
    private init()
    {
        self.session = NSURLSession(configuration: .defaultSessionConfiguration())
        self.template = NSURLComponents()
        self.configure()
    }
    
    private func configure()
    {
        self.template.scheme = "https"
        self.template.host = "api.github.com"
        do {
            if let token = try GitHubOAuth.shared.accessToken() {
                self.template.queryItems = [NSURLQueryItem(name: "access_token", value: token)]
            }
        }
        catch {
            
        }
    }
    
    func GETRepositories(completion: (repositories: [Repository]?)-> ())
    {
        
        
        self.template.path = "/user/repos"
        self.session.dataTaskWithURL(self.template.URL!) { (data, response, error)  in
            
            if let error = error {
                print(error)
            }
            
            if let data = data {
                do {
                    if let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions()) as? [[String : AnyObject]] {

                        var repositories = [Repository]()
                        
                        for repoJSON in json {
                            if let repository = Repository(json: repoJSON) {
                                repositories.append(repository)

                            }
                        }
                        
                        NSOperationQueue.mainQueue().addOperationWithBlock({ 
                            completion(repositories: repositories)
                        })
                    }
                }
                
                catch {
                
                }
            }
        
        }.resume()
    }
}