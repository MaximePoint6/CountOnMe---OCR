//
//  operation.swift
//  CountOnMe
//
//  Created by Maxime Point on 12/08/2022.
//  Copyright © 2022 Vincent Saluzzo. All rights reserved.
//

import Foundation

class Calculation {

    var delegate: ProtocolModel?
    var stringOperation: String = "1 + 1 = 2"

    // Variable separating the textview (at each space) into an array of String elements
    var elements: [String] {
        return stringOperation.split(separator: " ").map { "\($0)" }
    }

    // Variable retrieving the local decimal separator
    var localDecimalSeparator: String = Locale.current.decimalSeparator ?? "."

    // MARK: Error check computed variables
    var expressionHaveEnoughElement: Bool {
        return elements.count >= 3
    }

    var canAddOperatorOrDecimal: Bool {
        guard let lastElements = elements.last else {
            return false
        }
        let operators: [String] = Operator.allCases.map { $0.rawValue }
        return !operators.contains(lastElements) && String(lastElements.last!) != localDecimalSeparator
    }

    var numberHasDecimal: Bool {
        guard let lastElements = elements.last else {
            return false
        }
        return lastElements.contains(localDecimalSeparator)
    }

    var hasResult: Bool {
        return stringOperation.firstIndex(of: "=") != nil
    }

    // MARK: function for add composant or reset textview
    /// Function checking : if the operation has a result (if yes, then it resets the screen) and
    /// if a number or a decimal separator can be added to the screen (if yes, then the number is added in the textView,
    /// if not, nothing happens)
    /// - Parameter numberText: a number of text type
    func addNumber(numberText: String) {
        if hasResult {
            reset()
        }
        if (numberText == localDecimalSeparator && canAddOperatorOrDecimal
            && !numberHasDecimal) || (numberText != localDecimalSeparator) {
            stringOperation.append(numberText)
            self.delegate?.stringOperationWasUpdated()
        }
    }

    /// Function checking : if the operation has a result (if yes, then it resets the screen) and
    /// if a operator can be added to the screen (if yes, then the operator is added in the textView, if not,
    /// nothing happens)
    /// - Parameter numberText: a operator of text type
    func addOperator(operatorText: String) {
        if hasResult {
            reset()
        } else {
            if canAddOperatorOrDecimal {
                stringOperation.append(" \(operatorText) ")
                self.delegate?.stringOperationWasUpdated()
            }
        }
    }

    /// Function checking : if the operation has a result (if yes, then it resets the screen) and
    /// if a equal operator can be added to the screen (if yes, then the equal operator is added in the textView and
    /// the operation result function is called, if not , nothing happens)
    /// - Parameter numberText: a operator of text type
    func addEqualOperator() {
        if hasResult {
            reset()
        } else {
            guard expressionHaveEnoughElement && canAddOperatorOrDecimal else {
                self.delegate?.checkingExpressionHaveEnoughElement(expressionHaveEnoughElement:
                                                                        expressionHaveEnoughElement)
                return
            }
            operationProcessing()
        }
    }

    /// Function deleting the content of the textview
    func reset() {
        stringOperation = ""
        self.delegate?.stringOperationWasUpdated()
    }

    // MARK: function for calculation
    /// Function performing the operation and adding the result to the screen
    private func operationProcessing() {
        // Create local copy of operations
        var operationsToReduce = elements

        // Iterate over operations while an operand still here
        while operationsToReduce.count >= 3 {

            var leftIndex: Int
            var operatorIndex: Int
            var rightIndex: Int

            if let priorityOperatorIndex = prorityOperatorIndex(operationsToReduce: operationsToReduce) {
                operatorIndex = priorityOperatorIndex
                leftIndex = operatorIndex - 1
                rightIndex = operatorIndex + 1
            } else {
                operatorIndex = 1
                leftIndex = 0
                rightIndex = 2
            }

            let leftNumber = Decimal(string: operationsToReduce[leftIndex], locale: Locale.current)!
            let operand = operationsToReduce[operatorIndex]
            let rightNumber = Decimal(string: operationsToReduce[rightIndex], locale: Locale.current)!

            var result: Decimal = 0
            switch operand {
            case Operator.plus.rawValue: result = leftNumber + rightNumber
            case Operator.minus.rawValue: result = leftNumber - rightNumber
            case Operator.divider.rawValue:
                if rightNumber == 0 {
                    self.delegate?.checkingIsDivisionByZero(isDivisionByZero: true)
                    reset()
                    return
                } else {
                    result = leftNumber / rightNumber
                }
            case Operator.multiplier.rawValue: result = leftNumber * rightNumber
            default:
                print("Unknown operator !")
                return reset()
            }

            let stringResult = result.convertToStringWithLocalCurrent()
            operationsToReduce.remove(at: rightIndex)
            operationsToReduce.remove(at: operatorIndex)
            operationsToReduce.remove(at: leftIndex)
            operationsToReduce.insert("\(stringResult)", at: leftIndex)
        }
        stringOperation.append(" = \(operationsToReduce.first!)")
        self.delegate?.stringOperationWasUpdated()
    }

    /// Function returning the index of the priority operator to correctly perform an operation.
    /// - Parameter operationsToReduce: Array of type string including the elements that
    /// remain to be calculated in the operation.
    /// - Returns: index of the priority operator in the calculation
    private func prorityOperatorIndex(operationsToReduce: [String]) -> Int? {
        var firstIndex: Int?
        if let indexOfFirstDivison = operationsToReduce.firstIndex(of: Operator.divider.rawValue),
           let indexOfFirstMultiplication = operationsToReduce.firstIndex(of: Operator.multiplier.rawValue) {
            firstIndex = min(indexOfFirstDivison, indexOfFirstMultiplication)
        } else if let indexOfFirstDivison = operationsToReduce.firstIndex(of: Operator.divider.rawValue) {
            firstIndex = indexOfFirstDivison
        } else if let indexOfFirstMultiplication = operationsToReduce.firstIndex(of: Operator.multiplier.rawValue) {
            firstIndex = indexOfFirstMultiplication
        }
        return firstIndex
    }
}

extension Decimal {
    /// Function converting a decimal into a string taking into account the local decimal separator
    /// - Returns: the result of the conversion from decimal to string
    func convertToStringWithLocalCurrent() -> String {
        let text: NSNumber = self as NSNumber
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.locale = .current
        numberFormatter.maximumFractionDigits = 7
        numberFormatter.groupingSeparator = ""

        let result = numberFormatter.string(from: text) ?? ""
        return result
    }
}
