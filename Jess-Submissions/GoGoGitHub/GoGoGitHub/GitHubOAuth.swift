//
//  GitHubOAuth.swift
//  GoGoGitHub
//
//  Created by Jess Malesh on 6/27/16.
//  Copyright © 2016 Jess Malesh. All rights reserved.
//

import Foundation
import UIKit


let kAccessTokenKey = "KAccessTonkenKey"
let kOAuthBaseURLString = "https://github.com/login/oauth/"
let kAccessTokenRegexPattern = "access_token=([^%]+)"

typealias GitHubOAuthCompletion = (success: Bool) -> ()

//enum to handle errors

enum GitHubOAuthError: ErrorType
{
    case MissingAccessToken(String)
    case ExtractingTokenFromString(String)
    case ExtractingTemporyCode(String)
    case ResponseFromGitHub(String)
}

enum SaveOptions: Int
{
    case userDefaults
}



class GitHubOAuth
{
    //singleton
    static let shared = GitHubOAuth()
    
    private init(){}
    
    //oauth to leave app head to github and start oauth process
    func oAuthRequestWith(parameters: [String: String]) //pass in scope to auth users - email and user
    {
        var parameterString = String()
        
        for parameter in parameters.values { //loop through values in dict
            parameterString = parameterString.stringByAppendingString(parameter)
        }
        
        if let requestURL = NSURL(string: "\(kOAuthBaseURLString)authorize?client_id=\(kGitHubClientId)&scope=\(parameterString)"){ // base url
        
            print(requestURL)
            
            UIApplication.sharedApplication().openURL(requestURL) //puts url in safari to enter credentials or allow authorization
            
        }
       
        
    }
     //helper func to retreive temp code and bring it back
    
    func temporaryCodeFromCallback(url:NSURL) throws -> String
    {
        //add print to see what it looks like
        print("Callback url: \(url.absoluteString)")
        
        guard let temporaryCode = url.absoluteString.componentsSeparatedByString("=").last else {
            // .last grabs last value from url that came back 
            // component part actully seperates into array, grabbing last index)
            
            throw GitHubOAuthError.ExtractingTemporyCode("Error extracting temporary code from callback URL.")
            
        }
        
        print("Temporary Code: \(temporaryCode)")
        
        return temporaryCode
    }
    
    //helper function to create buffer to take in data and convert to string
    func stringWith(data: NSData) -> String?
    {
        let byteBuffer : UnsafeBufferPointer<UInt8> = UnsafeBufferPointer(start: UnsafeMutablePointer<UInt8>(data.bytes), count: data.length)
        
        let result = String(bytes: byteBuffer, encoding: NSASCIIStringEncoding)
        
        return result
        
    }
    
    //helper func handling actual token from github data - user left app, authed with git, came back to app and has access token
    
    func accessTokenFromString(string: String) throws -> String?
    {
        do {
            let regex = try NSRegularExpression(pattern: kAccessTokenRegexPattern, options: NSRegularExpressionOptions.CaseInsensitive)
            
            let matches = regex.matchesInString(string, options: .Anchored, range: NSMakeRange(0, string.characters.count))
            
            if matches.count > 0 { //if find matches, we loop through
                for (_, value) in matches.enumerate(){
                    print("MAth Range: \(value)")
                    let matchRange = value.rangeAtIndex(1)
                    return (string as NSString).substringWithRange(matchRange)
                }
                
                
            }
            
        } catch _ {
            throw GitHubOAuthError.ExtractingTokenFromString("Could not extract token from string")
        }
         return nil
        
    }
    
    //func saving access token
    func saveAccessTokenToUserDefaults(accessToken: String) -> Bool
    {
        
        NSUserDefaults.standardUserDefaults().setObject(accessToken, forKey: kAccessTokenKey) //think persistance for preferances
    
        return NSUserDefaults.standardUserDefaults().synchronize() //either true or false and we are passing it, will handle elsewhere
    
    }
    
    //put together temp code
    func tokenRequestWithCallback(url: NSURL, options: SaveOptions, completion: GitHubOAuthCompletion)
    {
        do {
            
            let temporaryCode = try self.temporaryCodeFromCallback(url) //grabs our code quickly
            
            let requestString = "\(kOAuthBaseURLString)access_token?client_id=\(kGitHubClientId)&client_secret=\(kGitHubClientSecret)&code=\(temporaryCode)"
            
            if let requestUrl = NSURL(string: requestString)
            {
                let sessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
                
                let session = NSURLSession(configuration: sessionConfiguration)
                
                session.dataTaskWithURL(requestUrl, completionHandler: { (data, response, error) in
                
                    if let _ = error {
                        completion(success: false); return
                    }
                    
                    
                    if let data = data {
                        if let tokenString = self.stringWith(data){
                            
                            do {
                                if let token = try self.accessTokenFromString(tokenString){
                                
                                NSOperationQueue.mainQueue().addOperationWithBlock({
                                    completion(success: self.saveAccessTokenToUserDefaults(token))
                                })
                            }
                            
                        } catch _ {
                            NSOperationQueue.mainQueue().addOperationWithBlock({
                                completion(success: false)
                            })
                        }
                    
                    }
                }
                
                }).resume()
        }
        
    } catch _ {
            NSOperationQueue.mainQueue().addOperationWithBlock({
                completion(success: false)
            })
        }
    
    }

    func accessToken() throws -> String
    {
        guard let accessToken = NSUserDefaults.standardUserDefaults().stringForKey(kAccessTokenKey) else {
            throw GitHubOAuthError.MissingAccessToken("There is no access token saved")
        }
        
        return accessToken
    }


}
































































