//
//  ProtocolModel.swift
//  CountOnMe
//
//  Created by Maxime Point on 30/08/2022.
//  Copyright © 2022 com.maximepoint. All rights reserved.
//

import Foundation

protocol ProtocolModel {
    func stringOperationWasUpdated()
    func checkingIsDivisionByZero(isDivisionByZero: Bool)
    func checkingExpressionHaveEnoughElement(expressionHaveEnoughElement: Bool)
}
