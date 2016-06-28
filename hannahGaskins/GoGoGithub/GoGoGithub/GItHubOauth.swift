//
//  GItHubOauth.swift
//  GoGoGithub
//
//  Created by hannah gaskins on 6/27/16.
//  Copyright © 2016 hannah gaskins. All rights reserved.
//

import UIKit
import Foundation

let kAccessTokenKey = "kAccessTokenKey"
let kOAuthBaseURLString = "https://github.com/login/oauth/"
let kAccessTokenRegexPattern = "access_token=([^&]+)"

typealias GitHubOAuthCompletion = (success: Bool) -> ()

// enum error handling for authenticaion

enum GitHubOAuthError: ErrorType {
    case MissingAccessToken(String)
    case ExtractingTokenFromString(String)
    case ExtractingTemporaryCode(String)
    case ResponseFromGithub(String)
}

enum SaveOptions: Int {
    case userDefaults // userDefaults in clear text but we need encrption on access tokens
    case Keychain
}

// implementing class

class GitHubOAuth {
    // singleton instance
    
    static let shared = GitHubOAuth()
    
    // private initializer
    private init() {}
    
    //oauth request that will take in params as a dictionary, kicks off leaving our app to GH to start oauth process
    // we will pass in email, user and these will be the parameters we will add to our calls
    func oAuthRequestWith(parameters: [String : String]) {
        
        var parameterString = String()
        
        // looping through all values in dictionary
        for parameter in parameters.values {
            parameterString = parameterString.stringByAppendingString(parameter)
        }
        
        //parametersString is the email,user
        if let requestURL = NSURL(string: "\(kOAuthBaseURLString)authorize?client_id=\(kGitHubClientID)&scope=\(parameterString)") {
            
            print(requestURL)
            
            UIApplication.sharedApplication().openURL(requestURL)
        }
    }
    
    func temporaryCodeFromCallback(url: NSURL) throws -> String {
        // print to see what url looks like coming in
        print("Callback URL: \(url.absoluteString)")
        
        // temporaryCode coming back in a URL
        guard let temporaryCode = url.absoluteString.componentsSeparatedByString("=").last else {
            // where we potentially get an error
            throw GitHubOAuthError.ExtractingTemporaryCode("Error Exacting Temporary Code From Callback URL.")
        }
        
        print("Temp Code: \(temporaryCode)")
        
        return temporaryCode
        
    }
    
    
    // creating function to handle the access token from the data passback from github using regex
    func accessTokenFromString(string: String) throws -> String? {
        do {
           
            let regex = try NSRegularExpression(pattern: kAccessTokenRegexPattern, options: NSRegularExpressionOptions.CaseInsensitive)
            
            let matches = regex.matchesInString(string, options: .Anchored, range: NSMakeRange(0, string.characters.count))
            
            if matches.count > 0 {
                for(_, value) in matches.enumerate() {
                    
                    print("Match RangeL \(value)")
                    // looping through matches if the matches are greater than 0
                    let matchRange = value.rangeAtIndex(1)
                    return (string as NSString).substringWithRange(matchRange)
                    
                }
            }
            
        } catch _ {
            
            throw GitHubOAuthError.ExtractingTokenFromString("Could Not Extract token from string.")
            
        }
        
        return nil
    }
    
    // MARK: Saving
    
    private func saveToKeychain(token: String) -> Bool {
        // stroying data as CoreFoundation
        var query = self.keychainQuery(kAccessTokenKey)
        // will return raw binary data
        query[(kSecValueData as String)] = NSKeyedArchiver.archivedDataWithRootObject(token)
        // by default it will delete everything in the space that app can interact with
        SecItemDelete(query)
        
        // then adding to teh keychain
        return SecItemAdd(query, nil) == errSecSuccess
        
    }
    
    private func keychainQuery(query: String) -> [String : AnyObject] {
        
        return [
            // specifying the type of data we are storing for data. kSecClassGenericPassword encripts
            (kSecClass as String) : kSecClassGenericPassword,
            (kSecAttrService as String) : query,
            (kSecAttrAccount as String) : query,
            (kSecAttrAccessible as String) : kSecAttrAccessibleAfterFirstUnlock // generic password can be accessed after first unlock
        ]
    }
    
    // creating a byte buffer and serializing our temporaryCode ourselves
    func stringWith(data: NSData) -> String? {
        // unsafeBufferPointer takes in Generics, writing a butter into space
        let byteBuffer : UnsafeBufferPointer<UInt8> = UnsafeBufferPointer<UInt8>(start: UnsafeMutablePointer<UInt8>(data.bytes), count: data.length)
        // takes data and converts it into a string. The temporary code that comes across is not JSON or english readable. but the data is just a bunch of bytes. we are using the size of the data to serialize the data ourselves.
        
        let result = String(bytes: byteBuffer, encoding: NSASCIIStringEncoding)
        
        return result
    }

    
    func saveAccessTokenToUserDefaults(accessToken: String) -> Bool {
        
        NSUserDefaults.standardUserDefaults().setObject(accessToken, forKey: kAccessTokenKey)
        
        // this will write it to a specific place within userDefaults
        return NSUserDefaults.standardUserDefaults().synchronize()
    }
    // takes in url to get a temporary code. we made helper functions to break steps up
    func tokenRequestWithCallback(url: NSURL, options: SaveOptions, completion: GitHubOAuthCompletion) {
        
        
        //
        func returnOnMain(success: Bool, _ completion: GitHubOAuthCompletion) {
            NSOperationQueue.mainQueue().addOperationWithBlock {
                completion(success: success)
            }
        }
        do {
            let temporaryCode = try self.temporaryCodeFromCallback(url)
            
            let requestString = "\(kOAuthBaseURLString)access_token?client_id=\(kGitHubClientID)&client_secret=\(kGitHubClientSecret)&code=\(temporaryCode)"
            // making string into acutal URL for request
            if let requestURL = NSURL(string: requestString) {
                
                // set up session configuration with default session
                let sessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
                // initialize our NSURLSession
                let session = NSURLSession(configuration: sessionConfiguration)
                //now we have our session, to manage the data tasks
                session.dataTaskWithURL(requestURL, completionHandler: { (data, response, error) in
                    
//                    if let _ = error {
//                        NSOperationQueue.mainQueue().addOperationWithBlock({
//                            completion(success: false); return
//                        })
//                        completion(success: false); return
//                    
//                    }
                    
                    if let data = data {
                        
                        if let tokenString = self.stringWith(data) {
                            
                            do {
                                if let token = try self.accessTokenFromString(tokenString) {
                                    
                                    switch options {
                                    case .userDefaults: returnOnMain(self.saveAccessTokenToUserDefaults(token), completion)
                                    case .Keychain: returnOnMain(self.saveToKeychain(token), completion)
                                    }
                                
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
                    
            }).resume()         // with any data task you need a .resume to fire off
            
        }
            
        } catch _ {
            
            NSOperationQueue.mainQueue().addOperationWithBlock({
                completion(success: false)
            })
            
        }
    }
    
    
    // function that checks if there is already a token in access defaults
    
    func accessToken() throws -> String? {
        
        var query = self.keychainQuery(kAccessTokenKey)
        query[(kSecReturnData as String)] = kCFBooleanTrue
        query[(kSecMatchLimit as String)] = kSecMatchLimitOne
        
        var dataRef: AnyObject?
        
        if SecItemCopyMatching(query, &dataRef) == errSecSuccess {
            // if success unwrap data
            if let data = dataRef as? NSData {
                // take data and create string
                if let token = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? String {
                    return token
                }
            }
        } else {
            
            
            guard let token = NSUserDefaults.standardUserDefaults().stringForKey(kAccessTokenKey) else {
                throw GitHubOAuthError.MissingAccessToken("There is no Access Token saved. ")
            }
            
            return token
        }
        
        return nil
    }
}






























