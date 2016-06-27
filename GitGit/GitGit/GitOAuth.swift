//
//  GitOAuth.swift
//  GitGit
//
//  Created by Derek Graham on 6/27/16.
//  Copyright © 2016 Derek Graham. All rights reserved.
//

import Foundation
import UIKit

let kAccessTokenKey = "kAccessTokenKey"

let kOAuthBaseURLString = "https://github.com/login/oauth/"
let kAccessTokenRegexPattern = "access_token=([^&]+)"

typealias GitHubOAuthCompletion = (success: Bool)-> ()

enum GitHubOAuthError: ErrorType {
    case MissingAccessToken(String)
    case ExtractingTokenFromString(String)
    case ExtractingTemporaryCode(String)
    case ResponseFromGitHub(String)
}

enum SaveOptions: Int {
    
    case userDefaults
    
}

class GitHubOAuth {
    
    static let shared = GitHubOAuth()
    
    private init() {}
    
    func OAuthRequestWith(parameters: [String: String])
    {
        var parameterString = String()
        
        for parameter in parameters.values{
            parameterString = parameterString.stringByAppendingString(parameter)
        }
        
        if let requestURL = NSURL(string: "\(kOAuthBaseURLString)authorize?client_id=\(kGitHubClientID)&scope=\(parameterString)") {
            
            print(requestURL)
            
            UIApplication.sharedApplication().openURL(requestURL)
        }
        
    }
    
    func temporaryCodeFromCallback(url: NSURL) throws -> String {
        guard let temporaryCode = url.absoluteString.componentsSeparatedByString("=").last else {
            throw GitHubOAuthError.ExtractingTemporaryCode("Error extracting temporary code from callback URL.")
            
        }
        print("Temporary code: \(temporaryCode)")
        return temporaryCode
    }
    
    func stringWith(data: NSData)-> String? {
        let byteBuffer: UnsafeBufferPointer = UnsafeBufferPointer<UInt8>(start: UnsafeMutablePointer<UInt8>(data.bytes), count: data.length)
        
        let result = String(bytes: byteBuffer, encoding: NSASCIIStringEncoding)
        
        return result
    }
    
    func accessTokenFromString(string: String) throws -> String? {
        
        do {
            let regex = try NSRegularExpression(pattern: kAccessTokenRegexPattern, options: NSRegularExpressionOptions.CaseInsensitive)
            let matches = regex.matchesInString(string, options: .Anchored, range: NSMakeRange(0, string.characters.count))
            
            if matches.count > 0 {
                for(_, value) in matches.enumerate() {
                    let matchRange = value.rangeAtIndex(1)
                    return (string as NSString).substringWithRange(matchRange)
                    
                }
                
            }
            
        } catch _ {
            throw GitHubOAuthError.ExtractingTokenFromString("Could not extract token from string.")
        }
        return nil
    }
    
    func saveAccessTokentoUserDefaults(accessToken: String) -> Bool {
        NSUserDefaults.standardUserDefaults().setObject(accessToken, forKey: kAccessTokenKey)
        return NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func tokenRequestWithCallback(url: NSURL, options: SaveOptions, completion: GitHubOAuthCompletion){
        
        do {
            let temporaryCode = try self.temporaryCodeFromCallback(url)
            
            let requestString = "\(kOAuthBaseURLString)access_token?client_id=\(kGitHubClientID)&client_secret=\(kGitHubSecret)&code=\(temporaryCode)"
            
            if let requestURL = NSURL(string: requestString){
                let sessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
                
                let session = NSURLSession(configuration: sessionConfiguration)
                
                session.dataTaskWithURL(requestURL, completionHandler: { (data, repsonse, error) in
                    
                    if let _ = error {
                        NSOperationQueue.mainQueue().addOperationWithBlock({ 
                            completion(success: false)
                            return

                        })
                    }
                    
                    if let data = data{
                        if let tokenString = self.stringWith(data) {
                            
                            do {
                                if let token = try self.accessTokenFromString(tokenString){
                                    print("saving token to user defaults")
                                    NSOperationQueue.mainQueue().addOperationWithBlock({
                                        completion(success: self.saveAccessTokentoUserDefaults(token))
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
        } catch {
            NSOperationQueue.mainQueue().addOperationWithBlock({ 
                completion(success: false)
            })
            
        }
        
    }
    
    func accessToken() throws -> String {
        print("trying to get access token from nsuserdefaults")
        guard let accessToken = NSUserDefaults.standardUserDefaults().stringForKey(kAccessTokenKey) else {
            throw GitHubOAuthError.MissingAccessToken("There is no access token saved")
            
        }
        
        return accessToken
    }
}












