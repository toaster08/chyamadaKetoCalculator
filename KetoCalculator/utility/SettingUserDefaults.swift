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

    private let ketogenicRatioTargetValueKey = "ketogenicRatioTargetValueKey"
    private let ketogenicIndexTargetValueKey = "ketogenicIndexTargetValueKey"
    private let ketogenicValueTargetValueKey = "ketogenicValueTargetValueKey"

    private let hasSavedFlugKey = "hasSavedFlugKey"

    let userDefaults = UserDefaults.standard

    func save(selectedEquation: Int) {
        userDefaults.set(selectedEquation, forKey: initialKetoEquationKey)
    }

    func save(targetKetogenicRatio targetValue: Double) {
        userDefaults.set(targetValue, forKey: ketogenicRatioTargetValueKey)
    }

    func save(targetKetogenicIndex targetValue: Double) {
        userDefaults.set(targetValue, forKey: ketogenicIndexTargetValueKey)
    }

    func save(targetKetogenicValue targetValue: Double) {
        userDefaults.set(targetValue, forKey: ketogenicValueTargetValueKey)
    }

    func save(totalEnergyExpenditure: Double) {
        userDefaults.setValue(totalEnergyExpenditure, forKey: totalEnergyExpenditureKey)
    }

    func hasSaved(flug: Bool) {
        userDefaults.set(flug, forKey: hasSavedFlugKey)
    }

    func loadDefaultIndexType() -> Int {
        let selectedEquation = userDefaults.integer(forKey: initialKetoEquationKey)
        return selectedEquation
    }

    func loadRaioDefaultTarget() -> Double {
        let targetValue = userDefaults.double(forKey: ketogenicRatioTargetValueKey)
        return targetValue
    }

    func loadIndexDefaultTarget() -> Double {
        let targetValue = userDefaults.double(forKey: ketogenicRatioTargetValueKey)
        return targetValue
    }

    func loadValueDefaultTarget() -> Double {
        let targetValue = userDefaults.double(forKey: ketogenicRatioTargetValueKey)
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
