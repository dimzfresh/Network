//
//  Network.swift
//  Network
//
//  Created by Dimz on 29.05.17.
//  Copyright © 2017 Dmitriy Zyablikov. All rights reserved.
//

import Foundation
import UIKit

class Network {
    
    class func performHTTPRequest(url: URLRequest, callback: ((Any?, HTTPURLResponse?, Error?) -> Void)?) {
        
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task = session.dataTask(with: url) { (data, response, error) in
            
            guard let data = data, error == nil else {
                // check for fundamental networking error
                print("error=\(error!)")
                callback?("Check internet connection", nil, error)
                return
            }
            
            //Response is sent here
            let httpResponse = response as? HTTPURLResponse
            
            do {
                if let resultJson = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] {
                        
                    callback?(resultJson, httpResponse, nil)
                }
                
            } catch {
                let responseString = String(data: data, encoding: .utf8)
                //print("responseString = \(responseString!)")
                callback?(responseString, httpResponse, nil)
            }
            
        }
        
        task.resume()
    }
    

}

final class MemesBackend: Backend {
    static var baseUrl: String {
        return "https://www.google.ru"
    }
}

extension MemesBackend {
    static func allMemesEndpoint() -> Endpoint {
        return allMemesEndpoint()
    }
    
    static func getMemeEndpoint(name: String) -> Endpoint {
        return GetMemeEndpoint(name: name)
    }
}

struct AllMemesEndpoint: Endpoint {
    var url: URL {
        return URL(string: MemesBackend.baseUrl + "/")!
    }
    
    var method: HTTPMethod {
        return .get
    }
}

struct GetMemeEndpoint: Endpoint {
    let name: String
    
    var url: URL {
        return URL(string: MemesBackend.baseUrl +  "\(name)")!
    }
    
    var method: HTTPMethod {
        return .get
    }
}

struct SignInEndpoint: Endpoint {
    let phone: String
    let code: String
    
    var url: URL {
        return URL(string: MemesBackend.baseUrl + "/name")!
    }
    
    var method: HTTPMethod {
        return .post
    }
    
    var headers: HTTPHeaderFields {
        // Custom headers
        return MemesBackend.authorizationHeaders(contentType: "application/x-www-form-urlencoded")
    }
    
    // Parameters might be dictionary or data or nil
    //    var parameters: Any? {
    //        return [
    //            "phone": phone,
    //            "code": code
    //        ]
    //    }
    
    
    var parameters: Any? {
        let postString = "phone=\(phone)&code=\(code)"
        return postString.data(using: .utf8)
    }
    
}

extension MemesBackend {
    
    static func authorizationHeaders(contentType: String) -> HTTPHeaderFields {
        //let authToken = "" // read the token from secure storage.
        return ["Content-Type" : contentType]
            //"Content-Type": "application/json",
            //"Content-Type": "text/html; charset=UTF-8",
            //"Authorization": authToken
        
    }
}




