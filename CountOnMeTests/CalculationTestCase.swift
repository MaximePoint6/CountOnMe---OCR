//
//  CountOnMeTests.swift
//  CountOnMeTests
//
//  Created by Maxime Point on 14/08/2022.
//  Copyright © 2022 com.maximepoint. All rights reserved.
//

import XCTest
@testable import CountOnMe
import Foundation

class CalculationTestCase: XCTestCase {

    var calculation: Calculation!
//    var localDecimalSeparator: String = Locale.current.decimalSeparator ?? "."

    override func setUp() {
        super.setUp()
        calculation = Calculation()
    }

    // MARK: WhenTestingAddNumber
    func testGivenElemenstIsEmpty_WhenTestingAddNumber2_ThenItShouldBe2() {
        calculation.stringOperation = ""
        calculation.addNumber(numberText: "2")
        XCTAssertEqual(calculation.elements.last, "2")
    }

    func testGivenElemenstIsEmpty_WhenTestingAddNumberLocalDecimal_ThenItShouldBeAnEmptyStringOperation() {
        calculation.stringOperation = ""
        calculation.addNumber(numberText: calculation.localDecimalSeparator)
        XCTAssertEqual(calculation.stringOperation, "")
    }

    func testGiven2_WhenTestingAddNumberLocalDecimal_ThenItShouldBe2Point() {
        calculation.stringOperation = "2"
        calculation.addNumber(numberText: calculation.localDecimalSeparator)
        XCTAssertEqual(calculation.elements.last, "2\(calculation.localDecimalSeparator)")
    }

    func testGiven2Point5_WhenTestingAddNumberLocalDecimal_ThenItShouldBe2Point5() {
        calculation.stringOperation = "2\(calculation.localDecimalSeparator)5"
        calculation.addNumber(numberText: calculation.localDecimalSeparator)
        XCTAssertEqual(calculation.elements.last, "2\(calculation.localDecimalSeparator)5")
    }

    func testGiven2Point5Multiplied_WhenTestingAddNumberLocalDecimal_ThenItShouldBe2Point5() {
        calculation.stringOperation = "2\(calculation.localDecimalSeparator)5 x "
        calculation.addNumber(numberText: calculation.localDecimalSeparator)
        XCTAssertEqual(calculation.stringOperation, "2\(calculation.localDecimalSeparator)5 x ")
    }

    func testGivenStringOperationWithResult_WhenTestingAddNumber2_ThenItShouldBe2() {
        calculation.stringOperation = "10 + 2 = 12"
        calculation.addNumber(numberText: "2")
        XCTAssertEqual(calculation.stringOperation, "2")
    }

    func testGivenStringOperationWithResult_WhenTestingAddNumberLocalDecimal_ThenItShouldBeAnEmptyStringOperation() {
        calculation.stringOperation = "10 + 2 = 12"
        calculation.addNumber(numberText: calculation.localDecimalSeparator)
        XCTAssertEqual(calculation.stringOperation, "")
    }

    // MARK: WhenTestingAddOperator
    func testGivenStringOperationWithResult_WhenTestingAddOperator_ThenItShouldBeAnEmptyStringOperation() {
        calculation.stringOperation = "10 + 2 = 12"
        calculation.addOperator(operatorText: "/")
        XCTAssertEqual(calculation.stringOperation, "")
    }

    func testGivenElemenstIsPlus_WhenTestingAddOperator_ThenItShouldBeSameStringOperation() {
        calculation.stringOperation = "10 + "
        calculation.addOperator(operatorText: "/")
        XCTAssertEqual(calculation.stringOperation, "10 + ")
    }

    func testGivenElemenstIs10_WhenTestingAddOperator_ThenItShouldBeSameStringOperationWithOperator() {
        calculation.stringOperation = "10"
        calculation.addOperator(operatorText: "/")
        XCTAssertEqual(calculation.stringOperation, "10 / ")
    }

    // MARK: WhenTestingisNotDivisionByZero withAddEqualOperator
    func testGivenDivideByZero_WhenTestingAddEqualOperator_ThenItShouldBeVoid() {
        calculation.stringOperation = "10 / 0"
        calculation.addEqualOperator()
        XCTAssertEqual(calculation.stringOperation, "")
    }

    func testGivenDivideByOtherThanZero_WhenTestingAddEqualOperator_ThenItShouldBeTrue() {
        calculation.stringOperation = "10 / 5"
        calculation.addEqualOperator()
        XCTAssertEqual(calculation.stringOperation, "10 / 5 = 2")
    }

    // MARK: WhenTestingAddEqualOperator
    func testGiven10Divided2Equals5_WhenTestingAddEqualOperator_ThenItShouldBeVoid() {
        calculation.stringOperation = "10 / 2 = 5"
        calculation.addEqualOperator()
        XCTAssertEqual(calculation.stringOperation, "")
    }

    func testGivenVoid_WhenTestingAddEqualOperator_ThenItShouldBeVoid() {
        calculation.stringOperation = ""
        calculation.addEqualOperator()
        XCTAssertEqual(calculation.stringOperation, "")
    }

    func testGiven10Divided2_WhenTestingAddEqualOperator_ThenItShouldBe5() {
        calculation.stringOperation = "10 / 2"
        calculation.addEqualOperator()
        XCTAssertEqual(calculation.elements.last, "5")
    }

    func testGiven10Multiplied2_WhenTestingAddEqualOperator_ThenItShouldBe20() {
        calculation.stringOperation = "10 x 2"
        calculation.addEqualOperator()
        XCTAssertEqual(calculation.elements.last, "20")
    }

    func testGiven10Minus2_WhenTestingAddEqualOperator_ThenItShouldBe8() {
        calculation.stringOperation = "10 - 2"
        calculation.addEqualOperator()
        XCTAssertEqual(calculation.elements.last, "8")
    }

    func testGiven10Minus12_WhenTestingAddEqualOperator_ThenItShouldBeMinus2() {
        calculation.stringOperation = "10 - 12"
        calculation.addEqualOperator()
        XCTAssertEqual(calculation.elements.last, "-2")
    }

    func testGiven10Plus2_WhenTestingAddEqualOperator_ThenItShouldBe12() {
        calculation.stringOperation = "10 + 2"
        calculation.addEqualOperator()
        XCTAssertEqual(calculation.elements.last, "12")
    }

    func testGiven5Plus2Multiplied10Minus10Divided2_WhenTestingAddEqualOperator_ThenItShouldBe20() {
        calculation.stringOperation = "5 + 2 x 10 - 10 / 2"
        calculation.addEqualOperator()
        XCTAssertEqual(calculation.elements.last, "20")
    }

    func testGiven2Point5Multiplied2Plus3Divided2_WhenTestingAddEqualOperator_ThenItShouldBe6Point5() {
        calculation.stringOperation = "2\(calculation.localDecimalSeparator)5 x 2 + 3 / 2"
        calculation.addEqualOperator()
        XCTAssertEqual(calculation.elements.last, "6\(calculation.localDecimalSeparator)5")
    }

    func testGiven2Unknown2_WhenTestingAddEqualOperator_ThenItShouldBeStringOperationIsEmpty() {
        calculation.stringOperation = "2 * 2"
        calculation.addEqualOperator()
        XCTAssertEqual(calculation.stringOperation, "")
    }

    func testGivenStringOperationWithResult_WhenTestingAddEqualOperator_ThenItShouldBeAnEmptyStringOperation() {
        calculation.stringOperation = "2 x 2 = 4"
        calculation.addEqualOperator()
        XCTAssertEqual(calculation.stringOperation, "")
    }

    func testGivenLastElementWithOperator_WhenTestingAddEqualOperator_ThenItShouldBeSameStringOperation() {
        calculation.stringOperation = "2 x 2 x "
        calculation.addEqualOperator()
        XCTAssertEqual(calculation.stringOperation, "2 x 2 x ")
    }

    func testGivenExpressionHaveNotEnoughElement_WhenTestingAddEqualOperator_ThenItShouldBeSameStringOperation() {
        calculation.stringOperation = "2 "
        calculation.addEqualOperator()
        XCTAssertEqual(calculation.stringOperation, "2 ")
    }

    func testGivenExpressionHave2Elements_WhenTestingAddEqualOperator_ThenItShouldBeSameStringOperation() {
        calculation.stringOperation = "2 x "
        calculation.addEqualOperator()
        XCTAssertEqual(calculation.stringOperation, "2 x ")
    }

    // MARK: WhenTestingReset
    func testGiven2Point5Multiplied2_WhenTestingReset_ThenItShouldBeStringOperationIsEmpty() {
        calculation.stringOperation = "2\(calculation.localDecimalSeparator)5 x 2"
        calculation.reset()
        XCTAssertEqual(calculation.stringOperation, "")
    }
}
