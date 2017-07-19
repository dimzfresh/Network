# Network
Simple network library

Describe endpoint. 
There is only one default header ["Content-Type": "application/json"].

struct AllMemesEndpoint: Endpoint {
    var url: URL {
        return URL(string: MemesBackend.baseUrl + "/")!
    }
    
    var method: HTTPMethod {
        return .get
    }
}

Describe base URL of a backend.

final class MemesBackend: Backend {
    static var baseUrl: String {
        return "https://www.google.ru"
    }
}

Implement your headers if it need.

extension MemesBackend {
    static func authorizationHeaders(contentType: String) -> HTTPHeaderFields {
        //let authToken = "" // read the token from secure storage.
        return ["Content-Type" : contentType]
            //"Content-Type": "application/json",
            //"Content-Type": "text/html; charset=UTF-8",
            //"Authorization": authToken      
    }
}

Example of an endpoint that takes one param and need custom headers.

struct GetMemeEndpoint: Endpoint {

    let name: String
    
    var url: URL {
        return URL(string: MemesBackend.baseUrl +  "\(name)")!
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var headers: HTTPHeaderFields {
        // Custom headers
        return MemesBackend.authorizationHeaders()
    }
}

Example of an endpoint to sign in user.

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
    
    var parameters: Any? {
        let postString = "phone=\(phone)&code=\(code)"
        return postString.data(using: .utf8)
    }
    
    // Parameters might be dictionary or data or nil
    //    var parameters: Any? {
    //        return [
    //            "phone": phone,
    //            "code": code
    //        ]
    //    }  
}

You can get URLRequest representation of Endpoint.

let endpoint = GetMemeEndpoint(name: "yourEndpointName")
let request = endpoint.request
            
Network.performHTTPRequest(url: request) { (data, response, error) in }
