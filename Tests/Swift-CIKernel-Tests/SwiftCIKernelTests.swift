//
//  SwiftCIKernelTests.swift
//  Swift-CIKernel-Tests
//
//  Created by Michal Tomlein on 05/12/2022.
//

import XCTest

final class SwiftCIKernelTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFilterAvailable() throws {
        let filter = FalseColorFilter()
        XCTAssert(filter.isAvailable)
    }

}
