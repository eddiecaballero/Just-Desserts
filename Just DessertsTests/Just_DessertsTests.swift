//
//  Just_DessertsTests.swift
//  Just DessertsTests
//
//  Created by Eddie Caballero on 5/25/22.
//

import XCTest
@testable import Just_Desserts

class Just_DessertsTests: XCTestCase {
    
    let id = "53015" //Krispy Kreme Donut
    let timeout = 3.0
    
    //MARK: - Network Manager Tests

    func testNetworkManagerDessertsCall() {
        
        let exp = expectation(description: "Get desserts from Network Manager.")
        
        NetworkManager.shared.call(endpoint: DessertEndpoint.desserts) { (result: Result<Payload, AngryError>) in
            switch result {
            case .success(let payload):
                guard let _ = payload.meals else {
                    XCTFail("Error: \(AngryError.noMealsError)")
                    return
                }
            case .failure(let error): XCTFail("Error: \(error)")
            }
            exp.fulfill()
        }
        
        waitForExpectations(timeout: timeout)
    }
    
    func testNetworkManagerDessertCall() {
        let exp = expectation(description: "Get dessert from Network Manager.")
        
        NetworkManager.shared.call(endpoint: DessertEndpoint.dessert(id: id)) { (result: Result<Payload, AngryError>) in
            switch result {
            case .success(let payload):
                guard let _ = payload.meals?.first else {
                    XCTFail("Error: \(AngryError.noMealsError)")
                    return
                }
            case .failure(let error): XCTFail("Error: \(error)")
            }
            exp.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }
    
    func testNetworkManagerGetImageNotPlaceholder() {
        
        let exp = expectation(description: "Get image from Network Manager is not placeholder.")
        
        let urlString = "https://www.themealdb.com/images/media/meals/4i5cnx1587672171.jpg" //Krispy Cream Donut image
        NetworkManager.shared.getImage(from: urlString, placeholderImage: DessertImage.placeholder) { image in
            XCTAssertNotEqual(image, DessertImage.placeholder)
            exp.fulfill()
        }
        
        waitForExpectations(timeout: timeout)
    }
    
    //MARK: - Dessert Service Tests
    
    func testDessertServiceGetDessertsAlphabeticallyOrderedByNames() {
        let exp = expectation(description: "Get desserts from Service aphabetically ordered by name.")
        
        NetworkManager.shared.call(endpoint: DessertEndpoint.desserts) { (result: Result<Payload, AngryError>) in
            switch result {
            case .success(let payload):
                guard let desserts = payload.meals else {
                    XCTFail("Error: \(AngryError.noMealsError)")
                    return
                }
                
                for i in 1..<desserts.count {
                    if desserts[i-1].strMeal.lowercased() > desserts[i].strMeal.lowercased() {
                        XCTFail("Desserts not alphabetically ordered by name.")
                    }
                }
                
            case .failure(let error): XCTFail("Error: \(error)")
            }
            exp.fulfill()
        }
        
        waitForExpectations(timeout: timeout)
    }
    
}
