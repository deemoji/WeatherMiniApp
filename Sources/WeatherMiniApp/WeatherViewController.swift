//
//  WeatherViewController.swift
//  
//
//  Created by Дмитрий Мартьянов on 06.09.2024.
//

import UIKit
import Kingfisher
import CoreLocation

public final class WeatherViewController: UIViewController {
    
    private let tempLabel: UILabel = {
        let label = UILabel()
        label.text = "Загрузка..."
        label.font = .preferredFont(forTextStyle: .title1)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let tempMinLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.text = "0.0"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let tempMaxLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.text = "100.0"
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.text = "Загрузка..."
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let weatherImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let colorForBackground: UIColor
    
    private let service = WeatherService()
    private let locationManager = LocationManager()
    
    
    public init(_ color: UIColor) {
        colorForBackground = color
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        locationManager.onAuthorizationStatusChange = { [weak self] status in
            if status == .authorizedWhenInUse || status == .authorizedAlways {
                self?.locationManager.startUpdatingLocation()
            } else {
                print("Auth denied")
            }
        }
        
        locationManager.onLocationUpdate = { [weak self] in
            self?.fetchWeather(for: $0.coordinate)
        }
    }
    
    private func setupUI() {
        func createStackView(axis: NSLayoutConstraint.Axis, distribution: UIStackView.Distribution, alignment: UIStackView.Alignment, arrangedSubviews: [UIView]) -> UIStackView {
            let stackView = UIStackView()
            stackView.axis = axis
            stackView.distribution = distribution
            stackView.alignment = alignment
            stackView.translatesAutoresizingMaskIntoConstraints = false
            arrangedSubviews.forEach { stackView.addArrangedSubview($0) }
            return stackView
        }
        view.backgroundColor = colorForBackground
        
        let mainStackView = createStackView(
            axis: .vertical,
            distribution: .fillProportionally,
            alignment: .fill,
            arrangedSubviews: []
        )
        
        view.addSubview(mainStackView)
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.topAnchor),
            mainStackView.rightAnchor.constraint(equalTo: view.rightAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mainStackView.leftAnchor.constraint(equalTo: view.leftAnchor)
        ])
        
        let secondStackView = createStackView(
            axis: .horizontal,
            distribution: .fillEqually,
            alignment: .fill,
            arrangedSubviews: [tempLabel, weatherImageView]
        )
        mainStackView.addArrangedSubview(secondStackView)
        
        let thirdStackView = createStackView(
            axis: .horizontal,
            distribution: .fillEqually,
            alignment: .fill,
            arrangedSubviews: [tempMinLabel, tempMaxLabel]
        )
        
        let fourthStackView = createStackView(
            axis: .horizontal,
            distribution: .fillEqually,
            alignment: .fill,
            arrangedSubviews: [thirdStackView, descriptionLabel]
        )
        mainStackView.addArrangedSubview(fourthStackView)
    }
    
    private func fetchWeather(for coordinate: CLLocationCoordinate2D) {
        service.fetchWeather(for: coordinate) { [weak self] responce in
            switch responce {
            case .success(let value):
                guard let weather = value.weather.first else { break }
                self?.tempLabel.text = "Температура: \(value.main.temp) °C"
                self?.tempMinLabel.text = "\(value.main.temp_min) °C"
                self?.tempMaxLabel.text = "\(value.main.temp_max) °C"
                self?.descriptionLabel.text = "\(weather.description)"
                let url = URL(string: "https://openweathermap.org/img/wn/\(weather.icon)@2x.png")
                self?.weatherImageView.kf.setImage(with: url)
            case .failure(let error):
                print("Ошибка: \(error.localizedDescription)")
            }
        }
        
    }
}

