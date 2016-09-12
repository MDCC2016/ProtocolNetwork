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
    var path: String { get }
    var method: HTTPMethod { get }
    var parameter: [String: AnyObject] { get }
    
    associatedtype Response: Decodable
}

extension Request {
    var parameter: [String: AnyObject] {
        return [:]
    }
}

protocol RequestSender {
    var host: String { get }
    func send<T: Request>(_ r: T, handler: @escaping (T.Response?) -> Void)
}

extension RequestSender {
    var host: String {
        return "http://api.onevcat.com"
    }
}

protocol Decodable {
    static func parse(data: Data) -> Self?
}

extension User: Decodable {
    static func parse(data: Data) -> User? {
        return User(data: data)
    }
}

struct URLSessionRequestSender: RequestSender {
    func send<T: Request>(_ r: T, handler: @escaping (T.Response?) -> Void) {
        let url = URL(string: host.appending(r.path))!
        var request = URLRequest(url: url)
        request.httpMethod = r.method.rawValue
        // request.httpBody = ???
        
        let task = URLSession.shared.dataTask(with: request) {
            data, res, error in
            if let data = data, let res = T.Response.parse(data: data) {
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
}
