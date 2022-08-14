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
    var localDecimalSeparator: String = Locale.current.decimalSeparator ?? "."

    override func setUp() {
        super.setUp()
        calculation = Calculation()
    }

    // MARK: WhenTestingCExpressionHaveEnoughElement
    func testGivenElemenstIsEmpty_WhenTestingCExpressionHaveEnoughElement_ThenItShouldBeFalse() {
        calculation.textView = ""
        XCTAssertFalse(calculation.expressionHaveEnoughElement)
    }

    // MARK: WWhenTestingCanAddOperatorOrDecimal
    func testGivenLastElementIsNumber_WhenTestingCanAddOperatorOrDecimal_ThenItShouldBeTrue() {
        calculation.textView = "12 "
        XCTAssertTrue(calculation.canAddOperatorOrDecimal)
    }

    func testGivenLastElementIsPlus_WhenTestingCanAddOperatorOrDecimal_ThenItShouldBeFalse() {
        calculation.textView = "1 + "
        XCTAssertFalse(calculation.canAddOperatorOrDecimal)
    }

    func testGivenLastElementIsMinus_WhenTestingCanAddOperatorOrDecimal_ThenItShouldBeFalse() {
        calculation.textView = "1 - "
        XCTAssertFalse(calculation.canAddOperatorOrDecimal)
    }

    func testGivenLastElementIsMultiplier_WhenTestingCanAddOperatorOrDecimal_ThenItShouldBeFalse() {
        calculation.textView = "1 x "
        XCTAssertFalse(calculation.canAddOperatorOrDecimal)
    }

    func testGivenLastElementIsDivider_WhenTestingCanAddOperatorOrDecimal_ThenItShouldBeFalse() {
        calculation.textView = "1 / "
        XCTAssertFalse(calculation.canAddOperatorOrDecimal)
    }

    func testGivenLastElementIsDecimal_WhenTestingCanAddOperatorOrDecimal_ThenItShouldBeFalse() {
        calculation.textView = "1\(localDecimalSeparator)"
        XCTAssertFalse(calculation.canAddOperatorOrDecimal)
    }

    // MARK: WhenTestingNumberHasDecimal
    func testGivenLastElementWithDecimal_WhenTestingNumberHasDecimal_ThenItShouldBeTrue() {
        calculation.textView = "1\(localDecimalSeparator)5"
        XCTAssertTrue(calculation.numberHasDecimal)
    }

    func testGivenLastElementWithDecimal_WhenTestingNumberHasDecimal_ThenItShouldBeFalse() {
        calculation.textView = "1 / 2"
        XCTAssertFalse(calculation.numberHasDecimal)
    }

    // MARK: WhenTestingisNotDivisionByZero
    func testGivenDivideByZero_WhenTestingIsNotDivisionByZero_ThenItShouldBeFalse() {
        calculation.textView = "10 / 0"
        calculation.operationResult()
        XCTAssertFalse(calculation.isNotDivisionByZero)
    }

    func testGivenDivideByOtherThanZero_WhenTestingIsNotDivisionByZero_ThenItShouldBeTrue() {
        calculation.textView = "10 / 5"
        calculation.operationResult()
        XCTAssertTrue(calculation.isNotDivisionByZero)
    }

    // MARK: WhenTestinghasResult
    func testGiven10Divided2Equals5_WhenTestingHasResult_ThenItShouldBeTrue() {
        calculation.textView = "10 / 2 = 5"
        XCTAssertTrue(calculation.hasResult)
    }

    func testGiven10Divided2_WhenTestingHasResult_ThenItShouldBeFalse() {
        calculation.textView = "10 / 2"
        XCTAssertFalse(calculation.hasResult)
    }

    // MARK: OperationResult
    func testGiven10Divided2_WhenTestingOperationResult_ThenItShouldBe5() {
        calculation.textView = "10 / 2"
        calculation.operationResult()
        XCTAssertEqual(calculation.elements.last, "5")
    }

    func testGiven10Multiplied2_WhenTestingOperationResult_ThenItShouldBe20() {
        calculation.textView = "10 x 2"
        calculation.operationResult()
        XCTAssertEqual(calculation.elements.last, "20")
    }

    func testGiven10Minus2_WhenTestingOperationResult_ThenItShouldBe8() {
        calculation.textView = "10 - 2"
        calculation.operationResult()
        XCTAssertEqual(calculation.elements.last, "8")
    }

    func testGiven10Minus12_WhenTestingOperationResult_ThenItShouldBeMinus2() {
        calculation.textView = "10 - 12"
        calculation.operationResult()
        XCTAssertEqual(calculation.elements.last, "-2")
    }

    func testGiven10Plus2_WhenTestingOperationResult_ThenItShouldBe12() {
        calculation.textView = "10 + 2"
        calculation.operationResult()
        XCTAssertEqual(calculation.elements.last, "12")
    }

    func testGiven5Plus2Multiplied10Minus10Divided2_WhenTestingOperationResult_ThenItShouldBe20() {
        calculation.textView = "5 + 2 x 10 - 10 / 2"
        calculation.operationResult()
        XCTAssertEqual(calculation.elements.last, "20")
    }

    func testGiven2Point5Multiplied2Plus3Divided2_WhenTestingOperationResult_ThenItShouldBe6Point5() {
        calculation.textView = "2\(localDecimalSeparator)5 x 2 + 3 / 2"
        calculation.operationResult()
        XCTAssertEqual(calculation.elements.last, "6\(localDecimalSeparator)5")
    }

    // XCTAssert
    // XCTAssertEqual
    // XCTAssertTrue
    // XCTAssertFalse
    // XCTAssertNil
    // XCTAssertNotNi

}
