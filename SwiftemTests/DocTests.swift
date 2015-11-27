//
//  SwiftemTests.swift
//  SwiftemTests
//
//  Created by InamuraHideto on 11/14/15.
//  Copyright © 2015 InamuraHideto. All rights reserved.
//

import XCTest
import SwiftyJSON
@testable import Swiftem

class SwiftemDocTests: XCTestCase {
    
    let token = "<token>"
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testDocs() {
        let filterId = 11423290
        let expectation = expectationWithDescription("")
        Swiftem(token: token).docs(filterId, categ: .All, date: ["20151127"]).readStatus(.All).execute { response in
            response.either(
                onLeft: { e in
                    expectation.fulfill()
                },
                onRight: { r in
                    print(r)
                    XCTAssertNotEqual(r.count, 0)
                    expectation.fulfill()
                }
            )
        }
        waitForExpectationsWithTimeout(5.0, handler: nil)
    }
    
    func testImmutableTuple() {
        let s = Swiftem(token: token).docs().filterId(1).date(["20151127"])
        let a = s.siteCateg(.All)
        let b = s.siteCateg(.TwoCH)
        XCTAssertNotEqual(a.build(), b.build())
    }
    
    func testImmutableDict() {
        let s = Swiftem(token: token).docs().filterId(1).date(["20151127"]).siteCateg(.All)
        let a = s.readStatus(.All)
        let b = s.readStatus(.Read)
        XCTAssertNotEqual(a.build(), b.build())
    }
    
}
