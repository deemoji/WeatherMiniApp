//
//  WeatherPreviewViewController.swift
//  
//
//  Created by Дмитрий Мартьянов on 08.09.2024.
//

import UIKit
import CoreLocation

public final class WeatherPreviewViewController: UIViewController {

    private let tempLabel: UILabel = {
        let label = UILabel()
        label.text = "Загрузка..."
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
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
        view.backgroundColor = colorForBackground
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.addArrangedSubview(tempLabel)
        stackView.addArrangedSubview(weatherImageView)
        stackView.addArrangedSubview(descriptionLabel)
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor),
            stackView.rightAnchor.constraint(equalTo: view.rightAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            stackView.leftAnchor.constraint(equalTo: view.leftAnchor)
        ])
    }

    private func fetchWeather(for coordinate: CLLocationCoordinate2D) {
        service.fetchWeather(for: coordinate) { [weak self] responce in
            switch responce {
            case .success(let value):
                guard let weather = value.weather.first else { break }
                self?.tempLabel.text = "Температура: \(value.main.temp) °C"
                self?.descriptionLabel.text = "\(weather.description)"
                let url = URL(string: "https://openweathermap.org/img/wn/\(weather.icon)@2x.png")
                self?.weatherImageView.kf.setImage(with: url)
            case .failure(let error):
                print("Ошибка: \(error.localizedDescription)")
            }
        }
        
    }

}
