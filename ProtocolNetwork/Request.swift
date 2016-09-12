//
//  Request.swift
//  ProtocolNetwork
//
//  Created by WANG WEI on 2016/08/16.
//  Copyright © 2016年 OneV's Den. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case GET
    case POST
}

protocol Request {
    var host: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var parameter: [String: AnyObject] { get }
    
    associatedtype Response
    func parse(data: Data) -> Response?
}

extension Request {
    var host: String {
        return "http://api.onevcat.com"
    }
    var parameter: [String: AnyObject] {
        return [:]
    }
    func send(handler: @escaping (Response?) -> Void ) {
        let url = URL(string: host.appending(path))!
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        // request.httpBody = ???
        
        let task = URLSession.shared.dataTask(with: request) {
            data, res, error in
            if let data = data, let res = self.parse(data: data) {
                DispatchQueue.main.async {
                    handler(res)
                }
            } else {
                DispatchQueue.main.async {
                    handler(nil)
                }
            }
        }
        task.resume()
    }
}

struct UserRequest: Request {
    let name: String
    var path: String {
        return "/users/\(name)"
    }
    let method: HTTPMethod = .GET
    
    typealias Response = User
    func parse(data: Data) -> User? {
        return User(data: data)
    }
}
