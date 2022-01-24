//
//  SettingUserDefaults.swift
//  KetoCalculator
//
//  Created by toaster on 2021/12/02.
//

import Foundation

final class SettingUserDefaults {
    private let initialKetoEquationKey = "initialKetoEquationKey"
    private let ketogenicIndexTypeTargetValueKey = "ketogenicIndexTypeTargetValueKey"
    private let totalEnergyExpenditureKey = "totalEnergyExpenditureKey"
    private let hasSavedFlugKey = "hasSavedFlugKey"

    let userDefaults = UserDefaults.standard

    func save(selectedEquation: Int) {
        userDefaults.set(selectedEquation, forKey: initialKetoEquationKey)
    }

    func save(targetValue: Double, targetValueKey: String) {
        userDefaults.set(targetValue, forKey: targetValueKey)
    }

    func save(TEE totalEnergyExpenditure: Double) {
        userDefaults.setValue(totalEnergyExpenditure, forKey: totalEnergyExpenditureKey)
    }

    func hasSaved(flug: Bool) {
        userDefaults.set(flug, forKey: hasSavedFlugKey)
    }

    func loadDefaultIndexType() -> Int {
        let selectedEquation = userDefaults.integer(forKey: initialKetoEquationKey)
        return selectedEquation
    }

    func loadDefaultTargetValue(targetValueKey: String) -> Double {
        let targetValue = userDefaults.double(forKey: targetValueKey)
        return targetValue
    }

    func loadDefaultTEE() -> Double { // TEE: Total Energy Expenditure
        let defaultTEE = userDefaults.double(forKey: totalEnergyExpenditureKey)
        return defaultTEE
    }

    func loadSavedFlug() -> Bool {
        let defaultFlug = userDefaults.bool(forKey: hasSavedFlugKey)
        return defaultFlug
    }
}
