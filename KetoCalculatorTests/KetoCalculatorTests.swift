//
//  KetoCalculatorTests.swift
//  KetoCalculatorTests
//
//  Created by toaster on 2022/01/11.
//

import XCTest
@testable import KetoCalculator

class KetoCalculatorTests: XCTestCase {
    let infomationVC
        = InformationViewController()

    func test脂質量判定_0以上で過不足なしを判定する() {
        let lipidRequirementString
            = infomationVC.judge(Of: 0.0499999999999)
        XCTAssertEqual(lipidRequirementString, "過不足なし", "エラーメッセージを付け加えられる")
    }

    func test脂質量判定_0以下で過不足なしと判定する() {
        let lipidRequirementString
            = infomationVC.judge(Of: -0.0499999)
        XCTAssertEqual(lipidRequirementString, "過不足なし", "エラーメッセージを付け加えられる")
    }

    func test脂質量判定_0以下で負の100g以下と判定する() {
        let lipidRequirementString
            = infomationVC.judge(Of: -99.95)
        XCTAssertEqual(lipidRequirementString, "-100g以上", "エラーメッセージを付け加えられる")
    }

    func test脂質量判定_正のgを判定する() {
        let lipidRequirementString
            = infomationVC.judge(Of: 0.050000000000000000001)
        XCTAssertEqual(lipidRequirementString, "+0.1g", "エラーメッセージを付け加えられる")
    }

    func test脂質量判定_負のgを判定する() {
        let lipidRequirementString
            = infomationVC.judge(Of: -0.050000000000000000001)
        XCTAssertEqual(lipidRequirementString, "-0.1g", "エラーメッセージを付け加えられる")
    }

    func test脂質量判定_100未満でg判定する() {
        let lipidRequirementString
            = infomationVC.judge(Of: 99.9499999999999)
        XCTAssertEqual(lipidRequirementString, "+99.9g", "エラーメッセージを付け加えられる")
    }

    func test脂質量判定_100未満で100g以上を判定する() {
        let lipidRequirementString
            = infomationVC.judge(Of: 99.9599999999999)
        XCTAssertEqual(lipidRequirementString, "+100g以上", "エラーメッセージを付け加えられる")
    }

    func test脂質量判定_100以上で100g以上を判定する() {
        let lipidRequirementString
            = infomationVC.judge(Of: 100.0000000000000001)
        XCTAssertEqual(lipidRequirementString, "+100g以上", "エラーメッセージを付け加えられる")
    }
}
