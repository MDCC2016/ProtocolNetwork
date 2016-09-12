//
//  ProtocolNetworkTests.swift
//  ProtocolNetworkTests
//
//  Created by WANG WEI on 2016/08/16.
//  Copyright © 2016年 OneV's Den. All rights reserved.
//

import XCTest
@testable import ProtocolNetwork

class ProtocolNetworkTests: XCTestCase {
    
    var sender: TestRequestSender!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sender = TestRequestSender()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sender = nil
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testUserRequest() {
        
        sender.send(UserRequest(name: "onevcat")) {
            user in
            XCTAssertNotNil(user)
            XCTAssertEqual(user!.name, "Wei Wang")
        }
    }
}


struct TestRequestSender: RequestSender {
    func send<T : Request>(_ r: T, handler: @escaping (T.Response?) -> Void) {
        switch r.path {
        case "/users/onevcat":
            guard let fileURL = Bundle(for: ProtocolNetworkTests.self).url(forResource: "users:onevcat", withExtension: "") else {
                fatalError()
            }
            guard let data = try? Data(contentsOf: fileURL) else {
                fatalError()
            }
            handler(T.Response.parse(data: data))
        default:
            fatalError("Unknown path")
        }
    }
}
