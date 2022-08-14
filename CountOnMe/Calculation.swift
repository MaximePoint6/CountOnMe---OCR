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
    return lastElements != "+" && lastElements != "-" && lastElements != "/" && lastElements != "x" &&
        lastElements.last! != "," && lastElements.last! != "."
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

    // MARK: fonction for calculation
    func operationResult() {
        // Create local copy of operations
        var operationsToReduce = elements

        // Iterate over operations while an operand still here
        while operationsToReduce.count >= 3 {
            let left = Decimal(string: operationsToReduce[0], locale: Locale.current)!
            let operand = operationsToReduce[1]
            let right = Decimal(string: operationsToReduce[2], locale: Locale.current)!

            var result: Decimal = 0
            switch operand {
            case "+": result = left + right
            case "-": result = left - right
            case "/":
                if right == 0 {
                    isNotDivisionByZero = false
                } else {
                    isNotDivisionByZero = true
                    result = left / right
                }
            case "x": result = left * right
            default:
                print("Unknown operator !")
            }

            let stringResult = result.convertToStringWithLocalCurrent()
            operationsToReduce = Array(operationsToReduce.dropFirst(3))
            operationsToReduce.insert("\(stringResult)", at: 0)
        }
        textView.append(" = \(operationsToReduce.first!)")
    }
}

extension Decimal {
    func convertToStringWithLocalCurrent() -> String {
        let text: NSNumber = self as NSNumber
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.locale = .current
        numberFormatter.maximumFractionDigits = 20
        numberFormatter.groupingSeparator = ""

        let result = numberFormatter.string(from: text) ?? ""
            return result
    }
}
