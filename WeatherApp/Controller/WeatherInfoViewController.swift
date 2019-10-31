//
//  WeatherInfoViewController.swift
//  WeatherApp
//
//  Created by Vidyaprasad on 31/10/19.
//  Copyright © 2019 Vidyaprasad. All rights reserved.
//

import UIKit

class WeatherInfoViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    
    var timer: Timer?
    var weatherDetail = [WeatherModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Weather Report"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateWeatherData()
        timer = Timer.scheduledTimer(timeInterval: 900.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer?.invalidate()
    }
    
    @objc func fireTimer() {
        updateWeatherData()
    }
    
    func updateWeatherData() {
        let weather = WeatherGetter()
        weather.getWeather(cities: ["4163971","2147714","2174003"]) {[weak self] (isSuccess, model) in
            if isSuccess {
                if let data = model {
                    self?.weatherDetail = data.list
                    DispatchQueue.main.async {
                        self?.tableview.reloadData()
                    }
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
    }
}
