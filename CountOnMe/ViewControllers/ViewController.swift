//
//  ViewController.swift
//  SimpleCalc
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet var numberButtons: [UIButton]!

    let calculation = Calculation()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDecimalSeparator()
        textView.isEditable = false
        updateTextView()
    }

    private func setupDecimalSeparator() {
        for button in numberButtons where button.tag == 1 {
            button.setTitle(calculation.localDecimalSeparator, for: .normal)
        }
    }

    private func updateTextView() {
        textView.text = calculation.textView
    }

    private func reset() {
        calculation.textView = ""
        updateTextView()
    }

    // MARK: View actions
    @IBAction func tappedNumberButton(_ sender: UIButton) {
        guard let numberText = sender.title(for: .normal) else {
            return
        }
        if calculation.hasResult {
            reset()
        }
        if (numberText == calculation.localDecimalSeparator && calculation.canAddOperatorOrDecimal
                              && !calculation.numberHasDecimal) || (numberText != calculation.localDecimalSeparator) {
                              calculation.textView.append(numberText)
                              updateTextView()
        }
    }

    @IBAction func tappedAdditionButton(_ sender: UIButton) {
        if calculation.hasResult {
            reset()
        } else {
            if calculation.canAddOperatorOrDecimal {
                calculation.textView.append(" + ")
                updateTextView()
            }
        }
    }

    @IBAction func tappedSubstractionButton(_ sender: UIButton) {
        if calculation.hasResult {
            reset()
        } else {
            if calculation.canAddOperatorOrDecimal {
                calculation.textView.append(" - ")
                updateTextView()
            }
        }
    }

    @IBAction func tappedDivisionButton(_ sender: UIButton) {
        if calculation.hasResult {
            reset()
        } else {
            if calculation.canAddOperatorOrDecimal {
                calculation.textView.append(" / ")
                updateTextView()
            }
        }
    }

    @IBAction func tappedMultiplicationButton(_ sender: UIButton) {
        if calculation.hasResult {
            reset()
        } else {
            if calculation.canAddOperatorOrDecimal {
                calculation.textView.append(" x ")
                updateTextView()
            }
        }
    }

    @IBAction func tappedEqualButton(_ sender: UIButton) {
        if calculation.hasResult {
            reset()
        } else {
            guard calculation.expressionHaveEnoughElement else {
                return calculationAlert()
            }
            guard calculation.canAddOperatorOrDecimal else {
                return
            }
            calculation.operationResult()
            guard calculation.isNotDivisionByZero else {
                return divideByZeroError()
            }
            updateTextView()
        }
    }

    @IBAction func tappedAllClearButton(_ sender: UIButton) {
        reset()
    }

    // MARK: Error Pop-up
    private func calculationAlert() {
        let alertVC = UIAlertController(title: "Erreur !",
                                        message: "Entrez une expression correcte composée d'au moins 2 nombres séparés par un opérateur.",
                                        preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }

    private func divideByZeroError() {
        let alertVC = UIAlertController(title: "Erreur !",
                                        message: "Impossible de diviser par zero.",
                                        preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
        reset()
    }
}
