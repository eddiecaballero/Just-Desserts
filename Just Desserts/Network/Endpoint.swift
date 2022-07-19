//
//  Endpoint.swift
//  Just Desserts
//
//  Created by Eddie Caballero on 7/13/22.
//

import Foundation

protocol Endpoint {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var parameters: [URLQueryItem] { get }
    var method: String { get }
}
