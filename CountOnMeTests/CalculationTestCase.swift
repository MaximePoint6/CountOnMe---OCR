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

    // MARK: WhenTestingCExpressionHaveEnoughElement
    func testGivenElemenstIsEmpty_WhenTestingCExpressionHaveEnoughElement_ThenItShouldBeFalse() {
        calculation.textView = ""
        XCTAssertFalse(calculation.expressionHaveEnoughElement)
    }

    func testGivenElemenstIsEmpty_WhenTestingCExpressionHaveEnoughElement_ThenItShouldBeTrue() {
        calculation.textView = "12 + 3"
        XCTAssertTrue(calculation.expressionHaveEnoughElement)
    }

    // MARK: WWhenTestingCanAddOperatorOrDecimal
    func testGivenElemenstIsEmpty_WhenTestingCanAddOperatorOrDecimal_ThenItShouldBeFalse() {
        calculation.textView = ""
        XCTAssertFalse(calculation.canAddOperatorOrDecimal)
    }

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

    func testGivenElementsWithMultipliers_WhenTestingCanAddOperatorOrDecimal_ThenItShouldBeFalse() {
        calculation.textView = "1 x 1 x"
        XCTAssertFalse(calculation.canAddOperatorOrDecimal)
    }

    func testGivenLastElementIsDivider_WhenTestingCanAddOperatorOrDecimal_ThenItShouldBeFalse() {
        calculation.textView = "1 / "
        XCTAssertFalse(calculation.canAddOperatorOrDecimal)
    }

    func testGivenLastElementIsDecimal_WhenTestingCanAddOperatorOrDecimal_ThenItShouldBeFalse() {
        calculation.textView = "1\(calculation.localDecimalSeparator)"
        XCTAssertFalse(calculation.canAddOperatorOrDecimal)
    }

    func testGivenLastElementWithDecimal_WhenTestingCanAddOperatorOrDecimal_ThenItShouldBeTrue() {
        calculation.textView = "1\(calculation.localDecimalSeparator)5"
        XCTAssertTrue(calculation.canAddOperatorOrDecimal)
    }

    // MARK: WhenTestingNumberHasDecimal
    func testGivenElemenstIsEmpty_WhenTestingNumberHasDecimal_ThenItShouldBeFalse() {
        calculation.textView = ""
        XCTAssertFalse(calculation.numberHasDecimal)
    }

    func testGivenLastElementWithDecimal_WhenTestingNumberHasDecimal_ThenItShouldBeTrue() {
        calculation.textView = "1\(calculation.localDecimalSeparator)5"
        XCTAssertTrue(calculation.numberHasDecimal)
    }

    func testGivenLastElementWithDecimal_WhenTestingNumberHasDecimal_ThenItShouldBeFalse() {
        calculation.textView = "1 / 2"
        XCTAssertFalse(calculation.numberHasDecimal)
    }

    // MARK: WhenTestingisNotDivisionByZero
    func testGivenDivideByZero_WhenTestingIsNotDivisionByZero_ThenItShouldBeFalse() {
        calculation.textView = "10 / 0"
        calculation.addEqualOperator()
        XCTAssertFalse(calculation.isNotDivisionByZero)
    }

    func testGivenDivideByOtherThanZero_WhenTestingIsNotDivisionByZero_ThenItShouldBeTrue() {
        calculation.textView = "10 / 5"
        calculation.addEqualOperator()
        XCTAssertTrue(calculation.isNotDivisionByZero)
    }

    // MARK: WhenTestinghasResult
    func testGivenElemenstIsEmpty_WhenTestingHasResult_ThenItShouldBeFalse() {
        calculation.textView = ""
        XCTAssertFalse(calculation.hasResult)
    }

    func testGiven10Divided2Equals5_WhenTestingHasResult_ThenItShouldBeTrue() {
        calculation.textView = "10 / 2 = 5"
        XCTAssertTrue(calculation.hasResult)
    }

    func testGiven10Divided2_WhenTestingHasResult_ThenItShouldBeFalse() {
        calculation.textView = "10 / 2"
        XCTAssertFalse(calculation.hasResult)
    }

    // MARK: WhenTestingAddNumber
    func testGivenElemenstIsEmpty_WhenTestingAddNumber2_ThenItShouldBe2() {
        calculation.textView = ""
        calculation.addNumber(numberText: "2")
        XCTAssertEqual(calculation.elements.last, "2")
    }

    func testGiven2_WhenTestingAddNumberLocalDecimal_ThenItShouldBe2Point() {
        calculation.textView = "2"
        calculation.addNumber(numberText: calculation.localDecimalSeparator)
        XCTAssertEqual(calculation.elements.last, "2\(calculation.localDecimalSeparator)")
    }

    func testGiven2Point5_WhenTestingAddNumberLocalDecimal_ThenItShouldBe2Point5() {
        calculation.textView = "2\(calculation.localDecimalSeparator)5"
        calculation.addNumber(numberText: calculation.localDecimalSeparator)
        XCTAssertEqual(calculation.elements.last, "2\(calculation.localDecimalSeparator)5")
    }

    func testGiven2Point5Multiplied_WhenTestingAddNumberLocalDecimal_ThenItShouldBe2Point5() {
        calculation.textView = "2\(calculation.localDecimalSeparator)5 x "
        calculation.addNumber(numberText: calculation.localDecimalSeparator)
        XCTAssertEqual(calculation.textView, "2\(calculation.localDecimalSeparator)5 x ")
    }

    func testGivenTextViewWithResult_WhenTestingAddNumber2_ThenItShouldBe2() {
        calculation.textView = "10 + 2 = 12"
        calculation.addNumber(numberText: "2")
        XCTAssertEqual(calculation.textView, "2")
    }

    func testGivenTextViewWithResult_WhenTestingAddNumberLocalDecimal_ThenItShouldBeAnEmptyTextView() {
        calculation.textView = "10 + 2 = 12"
        calculation.addNumber(numberText: calculation.localDecimalSeparator)
        XCTAssertEqual(calculation.textView, "")
    }

    // MARK: WhenTestingAddOperator
    func testGivenTextViewWithResult_WhenTestingAddOperator_ThenItShouldBeAnEmptyTextView() {
        calculation.textView = "10 + 2 = 12"
        calculation.addOperator(operatorText: "/")
        XCTAssertEqual(calculation.textView, "")
    }

    func testGivenElemenstIsPlus_WhenTestingAddOperator_ThenItShouldBeSameTextView() {
        calculation.textView = "10 + "
        calculation.addOperator(operatorText: "/")
        XCTAssertEqual(calculation.textView, "10 + ")
    }

    func testGivenElemenstIs10_WhenTestingAddOperator_ThenItShouldBeSameTextViewWithOperator() {
        calculation.textView = "10"
        calculation.addOperator(operatorText: "/")
        XCTAssertEqual(calculation.textView, "10 / ")
    }

    // MARK: WhenTestingAddEqualOperator
    func testGiven10Divided2_WhenTestingAddEqualOperator_ThenItShouldBe5() {
        calculation.textView = "10 / 2"
        calculation.addEqualOperator()
        XCTAssertEqual(calculation.elements.last, "5")
    }

    func testGiven10Multiplied2_WhenTestingAddEqualOperator_ThenItShouldBe20() {
        calculation.textView = "10 x 2"
        calculation.addEqualOperator()
        XCTAssertEqual(calculation.elements.last, "20")
    }

    func testGiven10Minus2_WhenTestingAddEqualOperator_ThenItShouldBe8() {
        calculation.textView = "10 - 2"
        calculation.addEqualOperator()
        XCTAssertEqual(calculation.elements.last, "8")
    }

    func testGiven10Minus12_WhenTestingAddEqualOperator_ThenItShouldBeMinus2() {
        calculation.textView = "10 - 12"
        calculation.addEqualOperator()
        XCTAssertEqual(calculation.elements.last, "-2")
    }

    func testGiven10Plus2_WhenTestingAddEqualOperator_ThenItShouldBe12() {
        calculation.textView = "10 + 2"
        calculation.addEqualOperator()
        XCTAssertEqual(calculation.elements.last, "12")
    }

    func testGiven5Plus2Multiplied10Minus10Divided2_WhenTestingAddEqualOperator_ThenItShouldBe20() {
        calculation.textView = "5 + 2 x 10 - 10 / 2"
        calculation.addEqualOperator()
        XCTAssertEqual(calculation.elements.last, "20")
    }

    func testGiven2Point5Multiplied2Plus3Divided2_WhenTestingAddEqualOperator_ThenItShouldBe6Point5() {
        calculation.textView = "2\(calculation.localDecimalSeparator)5 x 2 + 3 / 2"
        calculation.addEqualOperator()
        XCTAssertEqual(calculation.elements.last, "6\(calculation.localDecimalSeparator)5")
    }

    func testGiven2Unknown2_WhenTestingAddEqualOperator_ThenItShouldBeTextViewIsEmpty() {
        calculation.textView = "2 * 2"
        calculation.addEqualOperator()
        XCTAssertEqual(calculation.textView, "")
    }

    func testGivenTextViewWithResult_WhenTestingAddEqualOperator_ThenItShouldBeAnEmptyTextView() {
        calculation.textView = "2 x 2 = 4"
        calculation.addEqualOperator()
        XCTAssertEqual(calculation.textView, "")
    }

    func testGivenLastElementWithOperator_WhenTestingAddEqualOperator_ThenItShouldBeSameTextView() {
        calculation.textView = "2 x 2 x "
        calculation.addEqualOperator()
        XCTAssertEqual(calculation.textView, "2 x 2 x ")
    }

    func testGivenExpressionHaveNotEnoughElement_WhenTestingAddEqualOperator_ThenItShouldBeSameTextView() {
        calculation.textView = "2 "
        calculation.addEqualOperator()
        XCTAssertEqual(calculation.textView, "2 ")
    }

    // MARK: reset
    func testGiven2Point5Multiplied2_WhenTestingAddEqualOperator_ThenItShouldBeTextViewIsEmpty() {
        calculation.textView = "2\(calculation.localDecimalSeparator)5 x 2"
        calculation.reset()
        XCTAssertEqual(calculation.textView, "")
    }

    // XCTAssert
    // XCTAssertEqual
    // XCTAssertTrue
    // XCTAssertFalse
    // XCTAssertNil
    // XCTAssertNotNi

}
