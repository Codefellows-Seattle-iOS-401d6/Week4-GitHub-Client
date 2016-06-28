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
    
    case UserDefaults
    case Keychain
    
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
    
    private func saveToKeyChain(token: String)->Bool {
        
        var query = self.keychainQuery(kAccessTokenKey)
        // abstract into a struct
        query[(kSecValueData as String)] = NSKeyedArchiver.archivedDataWithRootObject(token)
        // key = kSecValueData : value = data ^
        SecItemDelete(query) // delete everything in your named space
        
        return SecItemAdd(query, nil) == errSecSuccess
        
        
    }
    
    private func keychainQuery(query: String)-> [String: AnyObject]{
        
        
        return [
            (kSecClass as String) : kSecClassGenericPassword,
            (kSecAttrService as String) : query, // app name or
            (kSecAttrAccount as String) : query, //account id / user id
            (kSecAttrAccessible as String) : kSecAttrAccessibleAfterFirstUnlock
        ]
    }
    
    func tokenRequestWithCallback(url: NSURL, options: SaveOptions, completion: GitHubOAuthCompletion){
        
        func returnOnMain(success: Bool, _ completion: GitHubOAuthCompletion) {
            NSOperationQueue.mainQueue().addOperationWithBlock { 
                completion(success: success); return
            }
        }
        
        do {
            let temporaryCode = try self.temporaryCodeFromCallback(url)
            
            let requestString = "\(kOAuthBaseURLString)access_token?client_id=\(kGitHubClientID)&client_secret=\(kGitHubSecret)&code=\(temporaryCode)"
            
            if let requestURL = NSURL(string: requestString){
                let sessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
                
                let session = NSURLSession(configuration: sessionConfiguration)
                
                session.dataTaskWithURL(requestURL, completionHandler: { (data, response, error) in
                    
                    if let _ = error {
                        
                        returnOnMain(false, completion)
                 
                    }
                    
                    if let data = data {
                                                
                        if let tokenString = String(data: data, encoding: NSUTF8StringEncoding) {
                            
                            do {
                                    if let token = try self.accessTokenFromString(tokenString){
                                    
                                    switch options {
                                    case .UserDefaults: returnOnMain(self.saveAccessTokentoUserDefaults(token), completion)
                                        
                                    case .Keychain: returnOnMain(self.saveToKeyChain(token), completion)
                                        
//                                    default:
                                    }
                                    
                                }
                            }

                                
                            catch  {
                                
                                returnOnMain(false, completion)
                          
                            }
                        }
                        
                    }
                    
                }).resume()
            }
        } catch {
            returnOnMain(false, completion)
    
            
        }
        
    }
    
    func accessToken() throws -> String? {
        print("trying to get access token")
        
        var query = self.keychainQuery(kAccessTokenKey)
        query[(kSecReturnData as String)] = kCFBooleanTrue
        query[(kSecMatchLimit as String )] = kSecMatchLimitOne
        
        var dataRef: AnyObject?
        
        if SecItemCopyMatching(query, &dataRef) == errSecSuccess {
            if let data = dataRef as? NSData {
                if let token = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? String {
                    return token
                }
            }
        }
        
        else {
            guard let token = NSUserDefaults.standardUserDefaults().stringForKey(kAccessTokenKey) else {
                throw GitHubOAuthError.MissingAccessToken("There is no access token saved")
                
            }
            return token
        }
  
    
    return nil
    }
}







