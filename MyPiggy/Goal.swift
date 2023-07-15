//
//  Goal.swift
//  MyPiggy
//
//  Created by Noel Rosario on 12/2/22.
//

import Foundation
import UIKit

enum GoalType {
    case basic
    case custom
    case broken
}

class Goal
{
    var goalKey: String
    var goalName: String
    var isBroken: Bool
    var amountCollectString: String
    var totalAmountCollected: Double
    var goalTotalAmount: Double
    var goalType: GoalType = .basic
    
    var goalTotal: String
    var savingType: String
    var completionDate: String
    
    init(json: [String: Any]) {
        self.goalKey = json["key"] as? String ?? ""
        self.goalName = json["goalName"] as? String ?? ""
        self.isBroken = json["isBroken"] as? Bool ?? false
        self.amountCollectString = json["amountCollected"] as? String ?? ""
        self.totalAmountCollected = Double(amountCollectString) ?? 0.0
        let goalTypeString = json["type"] as? String
        if goalTypeString == "Basic" {
            goalType = .basic
        } else {
            goalType = .custom
        }
        
        self.goalTotal = json["goalTotal"] as? String ?? ""
        self.savingType = json["savingType"] as? String ?? ""
        self.completionDate = json["completionDate"] as? String ?? ""
        self.goalTotalAmount = Double(goalTotal) ?? 0.0
    }
    
}


class History
{
    let date: String
    let key: String
    let totalBalance: String
    let saveAmout: String
    let isWithdrawl: Bool
    
    init(json: [String: Any]) {
        self.date = json["date"] as? String ?? ""
        self.key = json["key"] as? String ?? ""
        self.totalBalance = json["totalBalance"] as? String ?? ""
        self.saveAmout = json["saveAmount"] as? String ?? ""
        self.isWithdrawl = json["isWithdrawl"] as? Bool ?? false
    }
    
}
