//
//  ExtensionOfImage.swift
//  First-Collaboration-Refactoring
//
//  Created by Barbare Tepnadze on 19.05.24.
//

import Foundation

import BarbareDoesNetworking

protocol SpecieViewModelDelegate: AnyObject {
    func didFetchData()
}

class SpecieViewModel {
        
    // MARK: - Variables
    private var cityData = ""
    private let networkService = NetworkService()
    var observations: [Observation] = []

    weak var delegate: SpecieViewModelDelegate?
    
    // MARK: - Initialiser
    
    func fetchCountryCoordinates(city: String) {
        guard let url = URL(string: "https://api.inaturalist.org/v1/places/autocomplete?q=\(city)") else {
            fatalError("Invalid URL")
        }

        networkService.fetch(url: url, parse: { data -> AutocompleteResponse? in
            return try? JSONDecoder().decode(AutocompleteResponse.self, from: data)
        }) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let cityData):
                    self?.cityData = city
                    self?.fetchCountryData(cityID: cityData?.results.first?.id ?? 0)
                case .failure(let error):
                    print("Error fetching city ID:", error)
                }
            }
        }
    }


    func fetchCountryData(cityID: Int) {
        guard let url = URL(string: "https://api.inaturalist.org/v1/observations/species_counts?place_id=\(cityID)") else {
            fatalError("Invalid URL")
        }

        networkService.fetch(url: url, parse: { data -> SpeciesCountsResponse? in
            do {
                let speciesData = try JSONDecoder().decode(SpeciesCountsResponse.self, from: data)
                return speciesData
            } catch {
                print("Error decoding species counts data:", error)
                return nil
            }
        }) { [weak self] result in
            switch result {
            case .success(let speciesData):
                if let observations = speciesData?.results {
                    self?.observations = observations
                    DispatchQueue.main.async {
                        self?.delegate?.didFetchData()
                    }
                } else {
                    print("No observations found.")
                }
            case .failure(let error):
                print("Error fetching species counts:", error)
            }
        }
    }
    
    // MARK: - Computed Properties
    
    func getCityData() -> String {
        cityData
    }
    
    func getObservationsData() -> [Observation] {
        observations
    }
    
    func getObservationsCount() -> Int {
        observations.count
    }
}
