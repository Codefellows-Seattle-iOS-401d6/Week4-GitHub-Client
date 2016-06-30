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
    
    private var repository = Repository?()

    
    private init()
    {
        self.session = NSURLSession(configuration: .defaultSessionConfiguration())
        self.template = NSURLComponents()
        self.template.scheme = "https"
        self.template.host = "api.github.com"
//        self.template.query = "sort=created&direction=desc"
        self.getToken()
    }
    
    func getToken()
    {

        do {
            if let token = try GitHubOAuth.shared.accessToken() {
                self.template.queryItems = [NSURLQueryItem(name: "access_token", value: token)]
            }
        }
        catch {
            print("handle error here")
            
        }
    }
    
    func GETRepositories(completion: (repositories: [Repository]?, etag: AnyObject?)-> ())
    {
        
        
        self.template.path = "/user/repos"
        self.template.queryItems?.append(NSURLQueryItem(name: "sort", value: "created"))
        self.template.queryItems?.append(NSURLQueryItem(name: "direction", value: "desc"))

        self.session.dataTaskWithURL(self.template.URL!) { (data, response, error)  in
            
            if let error = error {
                print(error)
            }

            if let data = data {
                do {
                    if let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions()) as? [[String : AnyObject]] {

                        var repositories = [Repository]()
                        guard let response = response as? NSHTTPURLResponse else { return }
                        let etag = response.allHeaderFields["Etag"]

                        for repoJSON in json {
                            if let repository = Repository(json: repoJSON) {
                                repositories.append(repository)

                            }
                        }
                        
                        NSOperationQueue.mainQueue().addOperationWithBlock({ 
                            completion(repositories: repositories, etag: etag)
                        })
                    }
                }
                
                catch {
                
                }
            }
        
        }.resume()
    }
    
    func GETUser(completion: (user: User?) -> ()) {
        self.template.path = "/user"
        self.session.dataTaskWithURL(self.template.URL!) { (data, response, error)  in
            
            if let error = error {
                print(error)
            }
            if let data = data {
                do {
                    if let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions()) as? [String : AnyObject] {
                        
                        
//                        print(json)
                        let user = User(json: json)
                        
                        dispatch_async(dispatch_get_main_queue(), {
                        completion(user: user)
                            
                        })
                    }
                }
                catch {
                    
                }
            }
        
        }.resume()
    }
    
    func POSTRepository(name: String, completion: (success: Bool, repository: Repository?) -> ()){
        self.template.path = "/user/repos"
        let request = NSMutableURLRequest(URL: self.template.URL!)
        
        request.HTTPMethod = "POST"
        request.HTTPBody = try? NSJSONSerialization.dataWithJSONObject(["name" : name], options: .PrettyPrinted)
        let task = self.session.dataTaskWithRequest(request) { (data, response, error) in
            
            if let response = response as? NSHTTPURLResponse {
                
                switch response.statusCode {
                case 200...299:
                    if let data = data {
                        do {
                            if let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions()) as? [String : AnyObject] {
                                
//                                var repositories = [Repository]()
                                
//                                for repoJSON in json {
                                    if let repository = Repository(json: json) {
                                        self.repository = repository
//
                                    }
//                                }
                                
                            }
                        }
                            
                        catch {
                            print("error handling json")
                        }
                    }
                    print(self.repository)
                    dispatch_async(dispatch_get_main_queue(), { 
                        completion(success: true, repository: self.repository!)
                    })
                    
                default:
                    dispatch_async(dispatch_get_main_queue(), {
                        completion(success: true, repository: nil)
                    })
                    
                }
                
            }
        
            
        }
        
        task.resume()
        
    }
}