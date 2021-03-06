//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation


class WeatherViewController: UIViewController {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // location
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation() // this requires locationManager(_:didUpdateLocations:) from CLLocationManagerDelegate Protocol
        
        // Config: search text field informs view controller
        searchTextField.delegate = self
        
        // define delegate in weatherManager => delegate? is not null => didUpdateWeather is enabled
        weatherManager.delegate = self
    }
    
    @IBAction func currentLocationButtonPressed(_ sender: UIButton) {
        // location
        locationManager.requestLocation() // this requires locationManager(_:didUpdateLocations:) from CLLocationManagerDelegate Protocol
    }
    
}




//MARK: - UITextFieldDelegate


extension WeatherViewController: UITextFieldDelegate {  // UITextFieldDelegate is a protocol
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
        print(searchTextField.text!)
    }
    
    
    // ----------------------------------------------------------------------
    // The following functions are referring to any text field in this view.
    // These functions are not necessary because they are already covered in UITextFieldDelegate default implementation.
    // ----------------------------------------------------------------------
    
    // in search text field, pressing return button
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        print(searchTextField.text!)
        return true
    }
    
    // in search text field, when user end editing, i.e. searchTextField.endEditing(true)
    func textFieldDidEndEditing(_ textField: UITextField) {
        // use searchTextField.text to get the weather for that city
        if let city =  searchTextField.text {
            weatherManager.fetchedWeather(cityName: city)
        }
        
        searchTextField.text = ""
    }
    
    // in search field, if the user wants to end editing, do the following.
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            searchTextField.placeholder = "Type something here"
            return false
        }
    }
    
    // ----------------------------------------------------------------------
    // end
    // ----------------------------------------------------------------------
    
}


//MARK: - LocatioMaagerDelegate

extension WeatherViewController: CLLocationManagerDelegate { // CLLocationManagerDelegate is a Protocol. this allows us to use locationManager(_:didUpdateLocations:) method to obtain location
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchedWeather(latitude: lat, longitute: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("locationManager Error:: \(error)")
    }

}


//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
    
    // when weather is available, do this
    // by convention, in a delegate method, we have the identity of the object (i.e. weatherManager) that caused this method.
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async { // closure
            self.temperatureLabel.text = weather.temperature_formatted
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
            
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
}


