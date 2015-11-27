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

class SwiftemTests: XCTestCase {
    
    let token = "<token>"
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testLabels() {
        let clientId = 6
        let expectation = expectationWithDescription("")
        Swiftem(token: token).labels(clientId) { response in
            response.either(
                onLeft: { e in
                    expectation.fulfill()
                },
                onRight: { r in
                    XCTAssertNotEqual(r.count, 0)
                    expectation.fulfill()
                }
            )
        }
        waitForExpectationsWithTimeout(5.0, handler: nil)
    }
    
    
    let labelId = 1156083221
    let keywordId = 1102924640
    let docIds = ["1102924640-body-docs2015112416#http://www.keyman.or.jp/at/30006287/"]
    
    func testLabelSubmit() {
        let expectation = expectationWithDescription("")
        Swiftem(token: token).label(.Submit, labelId: labelId, keywordId: keywordId, docIds: docIds) { response in
            response.either(
                onLeft: { e in
                    expectation.fulfill()
                },
                onRight: { r in
                    XCTAssertEqual(r, 200)
                    expectation.fulfill()
                }
            )
        }
        waitForExpectationsWithTimeout(5.0, handler: nil)
    }
    
    func testLabelDelete() {
        let expectation = expectationWithDescription("")
        Swiftem(token: token).label(.Delete, labelId: labelId, keywordId: keywordId, docIds: docIds) { response in
            response.either(
                onLeft: { e in
                    expectation.fulfill()
                },
                onRight: { r in
                    XCTAssertEqual(r, 200)
                    expectation.fulfill()
                }
            )
        }
        waitForExpectationsWithTimeout(5.0, handler: nil)
    }
    
}
