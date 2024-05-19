//
//  PopulationViewController.swift
//  First-Collaboration-Refactoring
//
//  Created by Barbare Tepnadze on 19.05.24.
//


import UIKit

class PopulationViewController: UIViewController {
    
    // MARK: - Variables
    
    var viewModel: PopulationViewModel
    
    // MARK: - UI Components
    var populationTextField = UITextField()
    var populationButton = CustomButton(title: "Fetch Data", backgroundColor: .label, setTitleColor: .systemBackground)
    var todayPopulationView = CustomLongLayoutView()
    var tomorrowPopulationView = CustomLongLayoutView()
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.viewModel.delegate = self
        view.backgroundColor = .systemGray6
    }
    
    init(viewModel: PopulationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    func setupUI() {
        
        //Configure todayPopulationView
        
        todayPopulationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(todayPopulationView)
        
        //Configure tomorrowPopulationView
        tomorrowPopulationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tomorrowPopulationView)
        
        // Configure populationTextField
        populationTextField.placeholder = "Enter country name"
        populationTextField.translatesAutoresizingMaskIntoConstraints = false
        populationTextField.clipsToBounds = true
        populationTextField.layer.cornerRadius = 10
        populationTextField.backgroundColor = .systemBackground
        populationTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 14, height: populationTextField.frame.height))
        populationTextField.leftViewMode = .always
        view.addSubview(populationTextField)
        
        // Configure populationButton
        populationButton.addAction(UIAction(handler: { _ in
            self.fetchPopulationData()
        }), for: .touchUpInside)
        populationButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(populationButton)
        
        // Layout constraints
        NSLayoutConstraint.activate([
            populationTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            populationTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            populationTextField.heightAnchor.constraint(equalToConstant: 50),
            populationTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            populationTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            populationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            populationButton.topAnchor.constraint(equalTo: populationTextField.bottomAnchor, constant: 16),
            populationButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            populationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            todayPopulationView.topAnchor.constraint(equalTo: populationButton.bottomAnchor, constant: 16),
            todayPopulationView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            todayPopulationView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            tomorrowPopulationView.topAnchor.constraint(equalTo: todayPopulationView.bottomAnchor, constant: 16),
            tomorrowPopulationView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tomorrowPopulationView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    // MARK: - Setup Bindings

    func updateUI(){
        todayPopulationView.configure(leftText: "Today Population", rightText: viewModel.todayPopulationText ?? "")
        tomorrowPopulationView.configure(leftText: "Tomorrow Population", rightText: viewModel.tomorrowPopulationText ?? "")
    }
    
    // MARK: - Fetch Population Data
    func fetchPopulationData() {
        guard let country = populationTextField.text, !country.isEmpty else {
            return
        }
        viewModel.fetchCountryWeatherData(country: country)
    }
}

extension PopulationViewController: PopulationViewModelDelegate {
    func didFetchData() {
        DispatchQueue.main.async {
            self.updateUI()
        }
        
    }
    
    
}

