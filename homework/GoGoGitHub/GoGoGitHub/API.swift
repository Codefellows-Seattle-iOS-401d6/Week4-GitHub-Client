//
//  API.swift
//  GoGoGitHub
//
//  Created by Sung Kim on 6/28/16.
//  Copyright © 2016 Sung Kim. All rights reserved.
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
        self.template.scheme = "https"
        self.template.host = "api.github.com"
        self.getToken()
    }
    
    func getToken() {
        
        do {
            if let token = try GitHubOAuth.shared.accessToken() {
                self.template.queryItems = [NSURLQueryItem(name: "access_token", value: token)]
            }
        } catch {
            
        }

    }
    
    func GETRepositories(completion: (repositories: [Repository]?) -> ()) {
        self.template.path = "/user/repos"
        self.session.dataTaskWithURL(self.template.URL!) { (data, response, error) in
            if let error = error {
                print(error)
            }
            
            if let data = data {
                do {
                    if let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions()) as? [[String : AnyObject]] {
                        var repositories = [Repository]()
                        for repositoryJSON in json {
                            if let repository = Repository(json: repositoryJSON) {
                                repositories.append(repository)
                            }
                        }
                        NSOperationQueue.mainQueue().addOperationWithBlock({ 
                            completion(repositories: repositories)
                        })
                    }
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
    func GETUser(completion: (user: User?) -> ()) {
        self.template.path = "/user"
        self.session.dataTaskWithURL(self.template.URL!) { (data, response, error) in
            if let error = error {
                print(error)
            }
            if let data = data {
                do {
                    if let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions()) as? [String : AnyObject] {
                        
                        //create user
                        let user = User(json: json)
                        
                        NSOperationQueue.mainQueue().addOperationWithBlock({
                            completion(user: user)
                        })
                        //does the same thing
                        //dispatch_async(dispatch_get_main_queue(), {
                        //  completion(user: user)
                        //})

                    }
                } catch {
                    
                }
            }
        }.resume()
    }
    
    func POSTRepository(name: String, completion: (success: Bool) -> ()) {
        self.template.path = "/user/repos"
        //because this is a post method, we have to create a custom request
        
        let request = NSMutableURLRequest(URL: self.template.URL!)
        request.HTTPMethod = "POST"
        request.HTTPBody = try? NSJSONSerialization.dataWithJSONObject(["name" : name], options: NSJSONWritingOptions.PrettyPrinted)
        
        let task = self.session.dataTaskWithRequest(request) { (data, response, error) in
            if let error = error {
                print(error)
            }
            if let response = response as? NSHTTPURLResponse {
                switch response.statusCode {
                case 200...299:
                    dispatch_async(dispatch_get_main_queue(), {
                        completion(success: true)
                    })
                default:
                    dispatch_async(dispatch_get_main_queue(), {
                        completion(success: false)
                    })
                }
            }
        }
        
        task.resume()
    }
}





