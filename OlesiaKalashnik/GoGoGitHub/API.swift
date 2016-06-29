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
        self.setupToken()
    }
    
    func setupToken() {
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
                dispatch_async(dispatch_get_main_queue(), {
                    print(error)
                    completion(repos: nil)
                })
            }
            if let safeData = data {
                do {
                    if let json = try NSJSONSerialization.JSONObjectWithData(safeData, options: NSJSONReadingOptions()) as? [[String:AnyObject]] {
                        var repositories = [Repository]()
                        for repositoryJSON in json {
                            if let safeRepositoryJSON = Repository(json: repositoryJSON) {
                                repositories.append(safeRepositoryJSON)
                                //print(safeRepositoryJSON)
                            }
                        }
                        dispatch_async(dispatch_get_main_queue(), {
                            completion(repos: repositories)
                        })
                        
                    }
                } catch {
                    dispatch_async(dispatch_get_main_queue(), {
                        print("Failed in JSON serialization")
                        completion(repos: nil)
                    })
                }
            }
        }).resume()
    }
    
    func GETUser(completion: (user: User?)->()) {
        self.template.path = "/user"
        self.session.dataTaskWithURL(self.template.URL!) { (data, response, error) in
            if let error = error {
                dispatch_async(dispatch_get_main_queue(), {
                    completion(user: nil)
                })
                print(error)
            }
            if let safeData = data {
                do {
                    if let json = try NSJSONSerialization.JSONObjectWithData(safeData, options: NSJSONReadingOptions()) as? [String: AnyObject] {
                        let user = User(json: json)
                        dispatch_async(dispatch_get_main_queue(), {
                            completion(user: user)
                        })
                    }
                } catch {
                    dispatch_async(dispatch_get_main_queue(), {
                        completion(user: nil)
                    })
                    print("Can't serialize user")
                }
            }
            }.resume()
    }
    
    func POSTRepository(name: String, completion: (success: Bool) -> () ) {
        self.template.path = "/user/repos"
        let request = NSMutableURLRequest(URL: self.template.URL!)
        request.HTTPMethod = "POST"
        request.HTTPBody = try? NSJSONSerialization.dataWithJSONObject(["name": name], options: .PrettyPrinted)
        let task = self.session.dataTaskWithRequest(request) { (data, response, error) in
            if error != nil {
                print("POSTRepository Error")
                dispatch_async(dispatch_get_main_queue(), {
                    completion(success: false)
                })
            }
            if let response = response as? NSHTTPURLResponse {
                switch response.statusCode {
                case 200...299:
                    dispatch_async(dispatch_get_main_queue(), {
                        completion(success: true)
                        self.GETRepositories({ (repos) in
                            for repo in repos! {
                                print(repo)
                            }
                        })
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






