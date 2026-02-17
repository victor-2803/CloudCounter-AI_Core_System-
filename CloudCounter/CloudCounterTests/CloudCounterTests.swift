//
//  CloudCounterTests.swift
//  CloudCounterTests
//
//  Created by Mr.Chanoudom Tann on 17/2/2569 BE.
//

import XCTest
@testable import CloudCounter

final class CloudCounterTests: XCTestCase {

    func testIncrement() {
        let model = CounterModel()
        model.increment()
        XCTAssertEqual(model.value, 1)
    }

    func testDecrement() {
        let model = CounterModel()
        model.decrement()
        XCTAssertEqual(model.value, -1)
    }

    func testReset() {
        let model = CounterModel()
        model.increment()
        model.increment()
        model.reset()
        XCTAssertEqual(model.value, 0)
    }

    func testIsEvenRule() {
        let model = CounterModel()
        XCTAssertTrue(model.isEven())   // 0 is even
        model.increment()               // 1
        XCTAssertFalse(model.isEven())
        model.increment()               // 2
        XCTAssertTrue(model.isEven())
    }
}
