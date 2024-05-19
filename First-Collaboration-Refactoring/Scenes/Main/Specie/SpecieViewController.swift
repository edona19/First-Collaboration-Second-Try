//
//  SpecieViewController.swift
//  First-Collaboration-Refactoring
//
//  Created by Barbare Tepnadze on 19.05.24.
//

import UIKit
import BarbareDoesNetworking

class SpecieViewController: UIViewController{
    // MARK: - Variables
    var viewModel: SpecieViewModel
    
    // MARK: - UI Components
    
    let reviewOfPage: UILabel = {
        let label = UILabel()
        label.text = "This page will record a city and \nreturn you the last found species of \nanimals and plants in that city."
        label.textColor = .systemGray2
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var cityNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter a city"
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true
        textField.returnKeyType = .go
        textField.leftViewMode = .always
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 14, height: textField.frame.height))
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.leftViewMode = .always
        textField.backgroundColor = .systemBackground
        return textField
    }()

    let searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Search", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let cityIdLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let line: UIView = {
        let line = UIView()
        line.backgroundColor = .systemGray4
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
    }()

    let tableViewOfInformation: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.rowHeight = 100
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(SpecieTableViewCell.self, forCellReuseIdentifier: "SpecieTableViewCell")
        return tableView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        addSubviews()
        setupConstraints()
        testActions()
        tableViewOfInformation.dataSource = self
        tableViewOfInformation.delegate = self
        viewModel.delegate = self
    }
    
    init(viewModel: SpecieViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    func addSubviews() {
        view.addSubview(reviewOfPage)
        view.addSubview(cityNameTextField)
        view.addSubview(searchButton)
        view.addSubview(cityIdLabel)
        view.addSubview(tableViewOfInformation)
        view.addSubview(line)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            reviewOfPage.topAnchor.constraint(equalTo: view.topAnchor, constant: 70),
            reviewOfPage.bottomAnchor.constraint(equalTo: cityNameTextField.topAnchor, constant: -20),
            reviewOfPage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            reviewOfPage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            
            cityNameTextField.heightAnchor.constraint(equalToConstant: 40),
            cityNameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            cityNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            searchButton.heightAnchor.constraint(equalToConstant: 40),
            searchButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            searchButton.leadingAnchor.constraint(equalTo: cityNameTextField.trailingAnchor, constant: 16),
            searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchButton.widthAnchor.constraint(equalToConstant: 80),
            
            cityIdLabel.topAnchor.constraint(equalTo: cityNameTextField.bottomAnchor, constant: 20),
            cityIdLabel.leadingAnchor.constraint(equalTo: cityNameTextField.leadingAnchor),
            
            line.heightAnchor.constraint(equalToConstant: 2),
            line.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            line.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            line.bottomAnchor.constraint(equalTo: tableViewOfInformation.topAnchor),
            
            tableViewOfInformation.topAnchor.constraint(equalTo: cityIdLabel.bottomAnchor, constant: 20),
            tableViewOfInformation.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableViewOfInformation.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableViewOfInformation.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Action
    func testActions() {
        searchButton.addAction(UIAction(handler: { _ in
            self.searchButtonTapped()
        }), for: .touchUpInside)
    }

    func searchButtonTapped() {
        guard let cityName = cityNameTextField.text, !cityName.isEmpty else {
            cityIdLabel.text = "Please enter a city name"
            return
        }
        viewModel.fetchCountryCoordinates(city: cityName)
    }
    
    func updateUI() {
        tableViewOfInformation.reloadData()
        self.cityIdLabel.text = "City: \(viewModel.getCityData())"
    }
}

extension SpecieViewController: SpecieViewModelDelegate {
    func didFetchData() {
        DispatchQueue.main.async {
            self.updateUI()
        }
    }
}
