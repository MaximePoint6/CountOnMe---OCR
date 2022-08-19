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

    /// Function displaying the local decimal separator on the screen
    private func setupDecimalSeparator() {
        // button.tag == 1 corresponds to the decimal separator button
        for button in numberButtons where button.tag == 1 {
            button.setTitle(calculation.localDecimalSeparator, for: .normal)
        }
    }

    /// Function updating the TextView
    private func updateTextView() {
        textView.text = calculation.textView
    }

    // MARK: View actions
    /// Function triggered when the user clicks on a number or the decimal button, and updating the TextView.
    /// - Parameter sender: UIButton
    @IBAction func tappedNumberButton(_ sender: UIButton) {
        guard let numberText = sender.title(for: .normal) else {
            return
        }
        calculation.addNumber(numberText: numberText)
        updateTextView()
    }

    /// Function triggered when the user clicks on a operator button, and updating the TextView.
    /// - Parameter sender: UIButton
    @IBAction func tappedOperatorButton(_ sender: UIButton) {
        guard let operatorText = sender.title(for: .normal) else {
            return
        }
        calculation.addOperator(operatorText: operatorText)
        updateTextView()
    }

    /// Function triggered when the user clicks on a equal button.
    /// It checks if an alert message should be displayed on the screen and updating the TextView.
    /// - Parameter sender: UIButton
    @IBAction func tappedEqualButton(_ sender: UIButton) {
        calculation.addEqualOperator()
        if calculation.expressionHaveEnoughElement == false {
            alert(title: "Erreur !",
                  message: "Entrez une expression correcte composée d'au moins 2 nombres séparés par un opérateur.")
        } else if calculation.isNotDivisionByZero == false {
            alert(title: "Erreur !",
                  message: "Impossible de diviser par zero.")
        }
        updateTextView()
    }

    /// Function triggered when the user clicks on a AC button and delete the content of the textview
    /// - Parameter sender: UIButton
    @IBAction func tappedAllClearButton(_ sender: UIButton) {
        calculation.reset()
        updateTextView()
    }

    // MARK: Error Pop-up
    /// Function displaying an alert message
    /// - Parameter sender: UIButton
    private func alert(title: String, message: String) {
        let alertVC = UIAlertController(title: title,
                                        message: message,
                                        preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
}
