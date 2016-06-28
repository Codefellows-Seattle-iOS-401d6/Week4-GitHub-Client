//
//  GitHubOAuth.swift
//  GoGoGitHub
//
//  Created by Sean Champagne on 6/27/16.
//  Copyright © 2016 Sean Champagne. All rights reserved.
//

import UIKit

let kAccessTokenKey = "kAccessTokenKey" //access token key, used for being saved to user defaults
let kOAuthBaseURLString = "https://github.com/login/oauth/" //Endpoint
let kAccessTokenRegexPattern = "access_token=([^&]+)"

typealias GitHubOAuthCompletion = (success: Bool) -> () //returning void

enum GitHubOAuthError: ErrorType
{
    case MissingAccessToken(String)
    case ExtractingTokenFromString(String)
    case ExtracingTemporaryCode(String)
    case ResponseFromGitHub(String)
}

enum SaveOptions: Int
{
    case userDefaults
    
}

class GitHubOAuth
{
    static let shared = GitHubOAuth()
    
    private init() {} //requried for singleton declared above
    
    func oAuthRequestWith(parameters: [String : String]){ //passing in the scope where we authenticate the user
    
    var parametersString = String()
    
    for parameter in parameters.values
    {
    parametersString = parametersString.stringByAppendingString(parameter)
    }
        if let requestURL = NSURL(string: "\(kOAuthBaseURLString)authorize?client_id=\(kGitHubClientID)&scope=\(parametersString)"){
                print(requestURL)
                UIApplication.sharedApplication().openURL(requestURL)
}
}
    func temporaryCodeFromCallback(url: NSURL) throws -> String
    {
        print("Callback URL: \(url.absoluteString)")
        
        guard let temporaryCode = url.absoluteString.componentsSeparatedByString("=").last else
        {
            throw GitHubOAuthError.ExtracingTemporaryCode("Error extracting temporary code from callback URL.")
            
        }
        print("Temp Code: \(temporaryCode)")
        return temporaryCode
    }
    func stringWith(data: NSData) -> String?
    {
        let byteBuffer : UnsafeBufferPointer<UInt8> = UnsafeBufferPointer(start: UnsafeMutablePointer<UInt8>(data.bytes), count: data.length)
        
        let result = String(bytes: byteBuffer, encoding: NSASCIIStringEncoding)
        
        return result
    }
    func accessTokenFromString(string: String) throws -> String?
    {
        do
        {
            let regex = try NSRegularExpression(pattern: kAccessTokenRegexPattern, options: NSRegularExpressionOptions.CaseInsensitive)
            let matches = regex.matchesInString(string, options: .Anchored, range: NSMakeRange(0, string.characters.count))
            
            if matches.count > 0 //let matches sets any regex matches equal to the matches dictionary and goes into this if a match was found (match.count > 0)
            {
                for (_, value) in matches.enumerate()
                {
                    let matchRange = value.rangeAtIndex(1)
                    return (string as NSString).substringWithRange(matchRange) //returns the matches
                }
            }
        } catch _
        {
            throw GitHubOAuthError.ExtractingTokenFromString("Could not extract token from string.")
            
        }
        return nil
    }
    func saveAccessTokenToUserDefaults(accessToken: String) -> Bool
    {
        NSUserDefaults.standardUserDefaults().setObject(accessToken, forKey: kAccessTokenKey)
        return NSUserDefaults.standardUserDefaults().synchronize()
    }
    func tokenRequestWithCallback(url: NSURL, options: SaveOptions, completion: GitHubOAuthCompletion)
    {
        do
        {
            let temporaryCode = try self.temporaryCodeFromCallback(url)
            let requestString = "\(kOAuthBaseURLString)access_token?client_id=\(kGitHubClientID)&client_secret=\(kGitHubClientSecret)&code=\(temporaryCode)"
            
            if let requestURL = NSURL(string: requestString)
            {
                let sessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
                
                let session = NSURLSession(configuration: sessionConfiguration)
                
                session.dataTaskWithURL(requestURL, completionHandler: { (data, response, error) in
                    if let _ = error
                    {
                        NSOperationQueue.mainQueue().addOperationWithBlock({
                            completion(success: false)
                            return
                        })
                    }
                    if let data = data
                    {
                        if let tokenString = self.stringWith(data)
                        {
                            do
                            {
                                if let token = try self.accessTokenFromString(tokenString)
                                {
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
        } catch _
        {
            NSOperationQueue.mainQueue().addOperationWithBlock({
                completion(success: false)
            })
        }
    }
    func accessToken() throws -> String?
    {
        guard let accessToken = NSUserDefaults.standardUserDefaults().stringForKey(kAccessTokenKey) else
        {
            throw GitHubOAuthError.MissingAccessToken("There is no access token saved.")
        }
        return accessToken
    }
}