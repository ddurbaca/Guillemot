//
//  WeatherAlertTests.swift
//  WeatherAlertTests
//
//  Created by Dan Durbaca on 09.10.2023.
//

import XCTest
@testable import WeatherAlert

final class WeatherAlertTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testWeatherAlertService() {
        let e = expectation(description: "fetchWeatherAlerts")
        let weatherAlertService = WeatherAlertService()
        weatherAlertService.fetchWeatherAlerts() { (weatherAlertSearchResult, error) in
            XCTAssertNil(error, "Error \(error!.localizedDescription)")
            XCTAssertNotNil(weatherAlertSearchResult, "No weather alert search result")
            e.fulfill()
        }
        waitForExpectations(timeout: 5.0, handler: nil)
    }
}
