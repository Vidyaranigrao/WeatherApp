//
//  WeatherInfoViewController.swift
//  WeatherApp
//
//  Created by Vidyaprasad on 31/10/19.
//  Copyright © 2019 Vidyaprasad. All rights reserved.
//

import UIKit

enum SearchOption: String {
    case cityName = "Search by name"
    case cityLocation = "Search by Location"
}

class WeatherInfoViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var timer: Timer?
    var weatherDetail = [WeatherModel]()
    var weatherList = [CityDetail]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Weather Report"
        self.weatherList = DataManager.shared.loadInitialCities()
        showSpinner(isShow: false)
        timer = Timer.scheduledTimer(timeInterval: 900.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
        updateWeatherData()
    }
    
    func resetTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 900.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
    }
    
    @IBAction func didTapSearchCity(_ sender: Any) {
        showSearchOptions()
    }
    
    @objc func fireTimer() {
        updateWeatherData()
    }
    
    func showSpinner(isShow: Bool) {
        spinner.isHidden = !isShow
        tableview.isHidden = isShow
        if isShow {
            spinner.startAnimating()
        } else {
            spinner.stopAnimating()
        }
    }
    
    func presentSearchController(with searchOption: SearchOption) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "searchCity") as? SearchCityViewController else { return }
        vc.delegate = self
        vc.searchOption = searchOption
        let navController = UINavigationController(rootViewController: vc)
        self.navigationController?.present(navController, animated: true, completion: nil)
    }
    
    func showSearchOptions() {
        
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let firstAction: UIAlertAction = UIAlertAction(title: "Search city by name", style: .default) { [weak self] action -> Void in
            self?.presentSearchController(with: SearchOption.cityName)
        }
        
        let secondAction: UIAlertAction = UIAlertAction(title: "Search city by location", style: .default) {[weak self] action -> Void in
            self?.presentSearchController(with: SearchOption.cityLocation)
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in }
        
        actionSheetController.addAction(firstAction)
        actionSheetController.addAction(secondAction)
        actionSheetController.addAction(cancelAction)
        
        actionSheetController.popoverPresentationController?.sourceView = self.view
        present(actionSheetController, animated: true, completion: nil)
    }
    
    func updateWeatherData() {
        showSpinner(isShow: true)
        let weather = WeatherGetter()
        let ids = weatherList.map { String($0.id) }
        weather.getWeather(cities: ids) {[weak self] (isSuccess, model) in
            if isSuccess {
                if let data = model {
                    self?.weatherDetail = data.list
                    DispatchQueue.main.async {
                        self?.showSpinner(isShow: false)
                        self?.tableview.reloadData()
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self?.showSpinner(isShow: false)
                    let alertController = UIAlertController(title: "Error", message: "No Data available.", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(action)
                    self?.present(alertController, animated: true, completion: nil)
                }
            }
        }
//        weather.getWeather(cityId: "4163971") {[weak self] (isSuccess, model) in
//            if isSuccess {
//                if let data = model {
//                    self?.weatherDetail.append(data)
//                    DispatchQueue.main.async {
//                        self?.tableview.reloadData()
//                    }
//                }
//            }
    }
}

extension WeatherInfoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherDetail.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableview.dequeueReusableCell(withIdentifier: "weatherCell") as? WeatherCell  else {
            return UITableViewCell()
        }
        cell.updateCell(with: weatherDetail[indexPath.row])
        return cell
    }
}

extension WeatherInfoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "summary") as? WeatherDetailViewController else { return }
        vc.detail = weatherDetail[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension WeatherInfoViewController: CityDelegate {
    func didSelectCity(city: CityDetail) {
        weatherList.append(city)
        resetTimer()
        updateWeatherData()
    }
}
