//
//  GitHubOAuth.swift
//  GoGoGitHub
//
//  Created by Olesia Kalashnik on 6/27/16.
//  Copyright © 2016 Olesia Kalashnik. All rights reserved.
//

import UIKit

private struct Keys {
    static let kAccessTokenKey = "kAccessTokenKey"
    static let kOAuthBaseURLString = "https://github.com/login/oauth/"
    static let kAccessTokenRegexPattern = "access_token=([^&]+)"
}

typealias GitHubOAuthCompletion = (success: Bool) -> ()

enum GitHubOAuthError : ErrorType {
    case MissingAccessToken(String)
    case ExtractingTokenFromString(String)
    case ExtractingTemporaryCode(String)
    case ResponseFromGitHub(String)
}

enum saveOptions : Int {
    case Keychain
}

class GitHubOAuth {
    static let shared = GitHubOAuth()
    private init() {}
    
    func oAuthRequestWith(parameters: [String:String]) {
        var parametersString = String()
        for param in parameters.values {
            parametersString = parametersString.stringByAppendingString(param)
        }
        if let requestURL = NSURL(string: "\(Keys.kOAuthBaseURLString)authorize?client_id=\(kGitHubClientID)&scope=\(parametersString)") {
            print("RequestURL: \(requestURL)")
            UIApplication.sharedApplication().openURL(requestURL)
        }
        
    }
    //Helper func which returns the part of url (sent by server) after "=" as temperary code
    func temporaryCodeFromCallback(url: NSURL) throws -> String {
        guard let tempCode = url.absoluteString.componentsSeparatedByString("=").last else {
            print("Callback url: \(url)")
            throw GitHubOAuthError.ExtractingTemporaryCode("Extracting Temporary Code from Callback URL")
        }
        print("Callback url: \(url)")
        return tempCode
    }
    
    //serialization of "ourself"
    //taking data (access token from server) and converting it into a string
    func stringWith(data: NSData) -> String? {
        let byteBuffer: UnsafeBufferPointer = UnsafeBufferPointer<UInt8>(start: UnsafeMutablePointer<UInt8>(data.bytes), count: data.length)
        let result = String(bytes: byteBuffer, encoding: NSASCIIStringEncoding)
        return result
    }
    
    func accessTokenFromString(string: String) throws -> String? {
        do {
            let regex = try NSRegularExpression(pattern: Keys.kAccessTokenRegexPattern, options: NSRegularExpressionOptions.CaseInsensitive)
            let matches = regex.matchesInString(string, options: .Anchored, range: NSMakeRange(0, string.characters.count))
            if matches.count > 0 {
                for (_, value) in matches.enumerate() {
                    let matchRange = value.rangeAtIndex(1)
                    return (string as NSString).substringWithRange(matchRange)
                }
            }
        } catch _ {
            throw GitHubOAuthError.ExtractingTokenFromString("Could not extract token from string!")
        }
        return nil
    }
    
    func saveAccessTokenToUsersDefaults(acessToken: String) -> Bool {
        NSUserDefaults.standardUserDefaults().setObject(acessToken, forKey: Keys.kAccessTokenKey)
        return NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    private func saveToKeychain(token: String) -> Bool {
        var query = self.keychainQuery(Keys.kAccessTokenKey)
        query[(kSecValueData as String)] = NSKeyedArchiver.archivedDataWithRootObject(token)
        SecItemDelete(query)
        return SecItemAdd(query, nil) == errSecSuccess
    }
    
    private func keychainQuery(query: String) -> [String:AnyObject] {
        return [
            (kSecClass as String) : kSecClassGenericPassword,
            (kSecAttrService as String) : query,
            (kSecAttrAccount as String) : query,
            (kSecAttrAccessible as String) : kSecAttrAccessibleAfterFirstUnlock
        ]
    }
    
    
    func tokenRequestWithCallback(url: NSURL, options: saveOptions, completion: GitHubOAuthCompletion) {
        
        func returnOnMain(success: Bool, _ completion: GitHubOAuthCompletion) {
            NSOperationQueue.mainQueue().addOperationWithBlock {
                completion(success: success)
            }
        }
        
        do {
            let tempCode = try self.temporaryCodeFromCallback(url)
            let requestString = "\(Keys.kOAuthBaseURLString)access_token?client_id=\(kGitHubClientID)&client_secret=\(kGitHubClientSecret)&code=\(tempCode)"
            if let requestURL = NSURL(string: requestString) {
                let sessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
                let session = NSURLSession(configuration: sessionConfiguration)
                session.dataTaskWithURL(requestURL, completionHandler: {(data, response, error) in
                    if let _ = error {
                        returnOnMain(false, completion)
                    }
                    if let data = data {
                        if let tokenString = self.stringWith(data) {
                            do {
                                if let token = try self.accessTokenFromString(tokenString) {
                                    returnOnMain(self.saveToKeychain(token), completion)
                                }
                            } catch _ {
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
        var query = self.keychainQuery(Keys.kAccessTokenKey)
        query[(kSecReturnData as String)] = kCFBooleanTrue
        query[(kSecMatchLimit) as String] = kSecMatchLimitOne
        var dataRef : AnyObject?
        if SecItemCopyMatching(query, &dataRef) == errSecSuccess {
            if let data = dataRef as? NSData {
                if let token = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? String {
                    return token
                }
            }
        }
        return nil
    }
    
}