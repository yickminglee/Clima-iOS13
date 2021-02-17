
import Foundation


// Create a protocol, which requires the struct/class with this protocol to have the didUpdateWeather capability
protocol WeatherManagerDelegate {
    // by convention, in a delegate method, we always have the identity of the object (i.e. weatherManager) that caused this method.
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}


// Create Weather Manager
struct WeatherManager {
    let weatherURL =
        "https://api.openweathermap.org/data/2.5/weather?appid=9d710900941d4f8aa0ef322d208983ed&units=metric"
    
    // weather manager would delegate WeatherManagerDelegate to other struct or class
    var delegate: WeatherManagerDelegate?
    
    func fetchedWeather(cityName: String) {
        ///
        /// get API url and perform reuest
        ///
        
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
        //print(urlString)
    }
    
    func fetchedWeather(latitude: Double, longitute: Double) {
        ///
        /// get API url and perform reuest
        ///
        
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitute)"
        performRequest(with: urlString)
        print(urlString)
    }
    
    
    func performRequest(with urlString: String) { // note that "with" here is an external parameter name => more readable
        ///
        /// 4 steps to get api data
        ///
        
        // 1. create a url
        if let url = URL(string: urlString) { // do this as long as URL() do not fail or not null
            
            // 2. create a URLSession
            let session = URLSession(configuration: .default)
            
            // 3. give the session a task
            // original code, let task = session.dataTask(with: url, completionHandler: handle(data:response:error:))
            // use closure to perform the handle function
            let task = session.dataTask(with: url) { (data, response, error) in
                // check if there is error
                if error != nil {
                    // note: within closure, needs to use self
                    self.delegate?.didFailWithError(error: error!)
                    return // return means exit this function here.
                }
                
                // if there is data
                if let safeData = data {
//                    let dataString = String(data: safeData, encoding: .utf8)
//                    print(dataString)
                    
                    // if weather data can be parsed
                    if let weather = self.parseJson(safeData) {
                        
                        // perform didUpdateWeather,
                        // if the delegated struct/class has the WeatherManagerDelegate protocol and
                        // the delegate has been initialised (in viewDidLoad) and
                        // the didUpdateWeather() capability has been defined.
                        self.delegate?.didUpdateWeather(self, weather: weather) // note: within closure, needs to use self
                    }
                    
                }
            }
            
            // 4. start the task
            task.resume()
        }
    }
    
    
    func parseJson(_ weatherData: Data) -> WeatherModel? {
        ///
        /// Parse Json weather data into city name, temperature, condition id and condition name. stored within a WeatherModel.
        ///
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            
            let id = decodedData.weather[0].id
            let name = decodedData.name
            let temp = decodedData.main.temp
                        
            let weather = WeatherModel(conditionID: id, cityName: name, temperature: temp)
            return weather
        } catch {
            // print error from decode() method, if any
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    
}
