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
        self.getToken()
        
    }
    
    func getToken() {
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
    
    func GETuser(completion: (user: User?) -> ()) {
        self.template.path = "/user"
        self.session.dataTaskWithURL(self.template.URL!) { (data, response, error) in
        
            if let error = error {
                print(error)
            }
            
            if let data = data {
                do {
                    if let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions()) as? [String : AnyObject] {
                        
                        // create user....
                        let user = User(json: json)
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            completion(user: user)
                        })
                        
                        completion(user: user)
                    }
                    
                }
                catch{
                    // error handling here. if it fails you should still be calling the completion.
                }
            }
            
        }.resume()
    }
    
    func POSTRepository(name: String, completion: (success: Bool) -> ()) {
        //
        self.template.path = "/user/repos"
        
        let request = NSMutableURLRequest(URL: self.template.URL!)
        request.HTTPMethod = "POST"
        // the dictionary is based on GH documentation
        request.HTTPBody = try? NSJSONSerialization.dataWithJSONObject(["name" : name], options: .PrettyPrinted)
        
        let task = self.session.dataTaskWithRequest(request) { (data, response, error) in
            //
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














