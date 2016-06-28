//
//  API.swift
//  GoGoGithub
//
//  Created by hannah gaskins on 6/28/16.
//  Copyright © 2016 hannah gaskins. All rights reserved.
//

import Foundation

class API {
    
    static let shared = API()
    
    private let session: NSURLSession
    private let template: NSURLComponents
    
    private init() {
        self.session = NSURLSession(configuration: .defaultSessionConfiguration())
        self.template = NSURLComponents()
        self.configure()
    }
    
    private func configure() {
        //
        self.template.scheme = "https"
        self.template.host = "api.github.com"
        
        do {
            
            if let token = try GitHubOAuth.shared.accessToken() {
                self.template.queryItems = [NSURLQueryItem(name: "access_token", value: token)]
            }
        }
        catch {}
    }
    
    
    func GETRepositories(completion: (repositories: [Repository]?) -> ())
    {
        self.template.path = "/user/repos"
        self.session.dataTaskWithURL(self.template.URL!) { (data, response, error) in
            
            if let _ = error { self.returnOnMain(nil, completion: completion) }
            
            if let data = data {
                do {
                    
                    var repositories = [Repository]()
                    
                    if let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions()) as? [[String : AnyObject]] {
                        for repositoryJSON in json {
                            if let repository = Repository(json: repositoryJSON) {
                                repositories.append(repository)
                            }
                        }
                        
                        self.returnOnMain(repositories, completion: completion)
                    }
                }
                    
                catch {
                    self.returnOnMain(nil, completion: completion)
                }
            }
            
            }.resume()
    }
    
    private func returnOnMain(repositories: [Repository]?, completion: (repositories: [Repository]?) -> ()) {
        NSOperationQueue.mainQueue().addOperationWithBlock({
            completion(repositories: repositories)
        })
    }

    
    
//    func GET() {
//        self.template.path = "/user/repos"
//        self.session.dataTaskWithURL(self.template.URL!) { (data, response, error) in
//            
//            if let error = error {
//                print(error)
//            }
//            
//            if let data = data {
//                do {
//                    if let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions()) as? [[String : AnyObject]] {
//                        //
//                        print(json)
//                    }
//                }
//                catch {
//                    print(error)
//                }
//            }
//            
//        }.resume()
//    }
}














