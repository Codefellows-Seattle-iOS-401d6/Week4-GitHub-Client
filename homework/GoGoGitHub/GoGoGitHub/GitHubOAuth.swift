//
//  GitHubOAuth.swift
//  GoGoGitHub
//
//  Created by Sung Kim on 6/27/16.
//  Copyright © 2016 Sung Kim. All rights reserved.
//

import UIKit

let kAccessTokenKey = "kAccessTokenKey"
let kOAuthBaseURLString = "https://github.com/login/oauth/"
let kAccessTokenRegexPattern = "access_token=([^&]+)"

typealias GitHubOAuthCompletion = (success: Bool) -> ()

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
    
    private init(){}
    
    func oAuthRequestWith(parameters: [String: String]) {
        var parametersString = String()
        
        for parameter in parameters.values {
            parametersString = parametersString.stringByAppendingString(parameter)
        }
        
        if let requestURL = NSURL(string: "\(kOAuthBaseURLString)authorize?client_id=\(kGitHubClientID)&scope=\(parametersString)") {
            UIApplication.sharedApplication().openURL(requestURL)
        }
    }
    
    func temporaryCodeFromCallback(url: NSURL) throws -> String {
        print("Callback URL: \(url.absoluteString)")
        guard let temporaryCode = url.absoluteString.componentsSeparatedByString("=").last else {
            throw GitHubOAuthError.ExtractingTemporaryCode("Error Extracting Temporary Code From Callback URL")
        }
        print("Temp Code: \(temporaryCode)")
        
        return temporaryCode
    }
    
    func stringWith(data: NSData) -> String? {
        let byteBuffer : UnsafeBufferPointer<UInt8> = UnsafeBufferPointer(start: UnsafeMutablePointer<UInt8>(data.bytes), count: data.length)
        
        let result = String(bytes: byteBuffer, encoding: NSASCIIStringEncoding)
        
        return result
    }
    
    func accessTokenFromString(string: String) throws -> String? {
        do {
            let regex = try NSRegularExpression(pattern: kAccessTokenRegexPattern, options: NSRegularExpressionOptions.CaseInsensitive)
            
            let matches = regex.matchesInString(string, options: .Anchored, range: NSMakeRange(0, string.characters.count))
            
            if matches.count > 0 {
                for(_, value) in matches.enumerate() {
                    print("Match Range: \(value)")
                    let matchRange = value.rangeAtIndex(1)
                    return (string as NSString).substringWithRange(matchRange)
                }
            }
        } catch _ {
            throw GitHubOAuthError.ExtractingTokenFromString("Could Not Extract Token From String")
        }
        return nil
    }
    
    func saveAccessTokenToUserDefaults(accessToken: String) -> Bool {
        NSUserDefaults.standardUserDefaults().setObject(accessToken, forKey: kAccessTokenKey)
        
        return NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    private func saveToKeyChain(token: String) -> Bool {
        var query = self.keychainQuery(kAccessTokenKey)
        query[(kSecValueData as String)] = NSKeyedArchiver.archivedDataWithRootObject(token)
        SecItemDelete(query)
        
        return SecItemAdd(query, nil) == errSecSuccess
    }
    
    private func keychainQuery(query: String) -> [String : AnyObject] {
        return [
            (kSecClass as String) : kSecClassGenericPassword,
            (kSecAttrService as String) : query,
            (kSecAttrAccount as String) : query,
            (kSecAttrAccessible as String) : kSecAttrAccessibleAfterFirstUnlock
        ]
    }
    
    func tokenRequestWithCallback(url: NSURL, options: SaveOptions, completion: GitHubOAuthCompletion) {
        
        func returnOnMain(success: Bool, _ completion: GitHubOAuthCompletion) {
            NSOperationQueue.mainQueue().addOperationWithBlock { 
                completion(success: success)
            }
        }
        
        do {
            let temporaryCode = try self.temporaryCodeFromCallback(url)
            
            let requestString = "\(kOAuthBaseURLString)access_token?client_id=\(kGitHubClientID)&client_secret=\(kGitHubClientSecret)&code=\(temporaryCode)"
            
            if let requestURL = NSURL(string: requestString) {
                let sessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
                
                let session = NSURLSession(configuration: sessionConfiguration)
                
                session.dataTaskWithURL(requestURL, completionHandler: { (data, response, error) in
                    if let _ = error {
                        returnOnMain(false, completion)
                    }
                    
                    if let data = data {
                        if let tokenString = self.stringWith(data) {
                            do {
                                let token = try self.accessTokenFromString(tokenString)!
                                
                                switch options {
                                    case .UserDefaults: returnOnMain(self.saveAccessTokenToUserDefaults(token), completion)
                                    case .Keychain: returnOnMain(self.saveToKeyChain(token), completion)
                                }
                                
                            } catch _ {
                                returnOnMain(false, completion)
                            }
                        }
                    }
                }).resume()
            }
        } catch _ {
            returnOnMain(false, completion)        }
    }
    
    func accessToken() throws -> String? {
        var query = self.keychainQuery(kAccessTokenKey)
        query[(kSecReturnData as String)] = kCFBooleanTrue
        query[(kSecMatchLimit as String)] = kSecMatchLimitOne
        
        var dataRef: AnyObject?
        
        if SecItemCopyMatching(query, &dataRef) == errSecSuccess {
            if let data = dataRef as? NSData {
                if let token = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? String {
                    return token
                }
            }
        } else {
            guard let accessToken = NSUserDefaults.standardUserDefaults().stringForKey(kAccessTokenKey) else {
                throw GitHubOAuthError.MissingAccessToken("There is no Access Token Saved")
            }
            return accessToken
        }
        return nil
    }
}
