//
//  PopulationModel.swift
//  First-Collaboration-Refactoring
//
//  Created by Barbare Tepnadze on 19.05.24.
//


import Foundation

struct PopulationResponse: Codable {
    let total_population: [Population]
}

struct Population: Codable {
    let date: String
    let population: Int
}
