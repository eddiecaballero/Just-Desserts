//
//  AngryError.swift
//  Just Desserts
//
//  Created by Eddie Caballero on 5/25/22.
//

import Foundation

enum AngryError: String, Error {
    case idError = "Invalid Meal ID? No 🧁 for you!"
    case gotError = "Got Error? No 🧁 for you!"
    case statusCodeError = "No status code 200? No 🧁 for you!"
    case dataError = "Invalid Data? No 🧁 for you!"
    case decodeError = "Unable to decode? No 🧁 for you!"
    case noMealsError = "No meals? No 🧁 for you!"
}
