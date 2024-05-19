//
//  SpecieViewModel.swift
//  First-Collaboration-Refactoring
//
//  Created by Barbare Tepnadze on 19.05.24.
//

import UIKit

extension SpecieViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.getObservationsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SpecieTableViewCell", for: indexPath) as! SpecieTableViewCell
        let observation = viewModel.getObservationsData()
        cell.selectionStyle = .none
        cell.configure(specieName: observation[indexPath.row].taxon.name ?? "Unknown",
                       nameUploader: observation[indexPath.row].taxon.default_photo?.attribution ?? "",
                       image: observation[indexPath.row].taxon.default_photo?.square_url ?? "",
                       wikipediaURL: observation[indexPath.row].taxon.wikipedia_url)
        return cell
    }
}


extension SpecieViewController: UITableViewDelegate {
    
}
