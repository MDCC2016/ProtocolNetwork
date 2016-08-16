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
    func parse(data: Data) -> Response
}

extension Request {
    var host: String {
        return "http://api.onevcat.com"
    }
    var parameter: [String: AnyObject] {
        return [:]
    }
    func send(handler: (Response?) -> Void ) {
        let url = URL(string: host.appending(path))!
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        // request.httpBody = ???
        
        URLSession.shared.dataTask(with: request) {
            data, res, error in
            if let data = data {
                let res = self.parse(data: data)
                handler(res)
            } else {
                handler(nil)
            }
        }
    }
}
