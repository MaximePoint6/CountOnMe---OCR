//
//  operation.swift
//  CountOnMe
//
//  Created by Maxime Point on 12/08/2022.
//  Copyright © 2022 Vincent Saluzzo. All rights reserved.
//

import Foundation

class Calculation {

    var textView: String = "1 + 1 = 2"

    var elements: [String] {
        return textView.split(separator: " ").map { "\($0)" }
    }

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

    var isNotDivisionByZero: Bool = true

    var hasResult: Bool {
        return textView.firstIndex(of: "=") != nil
    }

    // MARK: function for add composant or reset textview
    func addNumber(numberText: String) {
        if hasResult {
            reset()
        }
        if (numberText == localDecimalSeparator && canAddOperatorOrDecimal
            && !numberHasDecimal) || (numberText != localDecimalSeparator) {
            textView.append(numberText)
        }
    }

    func addOperator(operatorText: String) {
        if hasResult {
            reset()
        } else {
            if canAddOperatorOrDecimal {
                textView.append(" \(operatorText) ")
            }
        }
    }

    func addEqualOperator() {
        if hasResult {
            reset()
        } else {
            guard expressionHaveEnoughElement else {
                return
            }
            guard canAddOperatorOrDecimal else {
                return
            }
            operationResult()
            guard isNotDivisionByZero else {
                return reset()
            }
        }
    }

    func reset() {
        textView = ""
    }

    // MARK: function for calculation
    private func operationResult() {
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
                    isNotDivisionByZero = false
                } else {
                    isNotDivisionByZero = true
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
        textView.append(" = \(operationsToReduce.first!)")
    }

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
    // utiliser l'enum
}

extension Decimal {
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
