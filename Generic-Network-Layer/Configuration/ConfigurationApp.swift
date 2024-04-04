//
//  ConfigurationApp.swift
//  Generic-Network-Layer
//
//  Created by Raphaël Huang-Dubois on 04/04/2024.
//

import Foundation

enum EnvironmentApp: String {
    case dev
    case staging
    case production
}

enum ConfigurationApp {
    enum API {
        static var baseUrl: String {
            "https://meowfacts.herokuapp.com"
        }
    }
}
