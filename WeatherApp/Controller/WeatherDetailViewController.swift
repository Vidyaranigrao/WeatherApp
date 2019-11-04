//
//  WeatherDetailViewController.swift
//  WeatherApp
//
//  Created by Vidya on 05/11/19.
//  Copyright © 2019 Vidyaprasad. All rights reserved.
//

import UIKit

class WeatherDetailViewController: UIViewController {
    var detail: WeatherModel?
    
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Weather Summary"
        updateSummary()
    }

    func updateSummary() {
        guard  let info = detail else {
            return
        }
        self.nameLabel.text = info.name
        let descr = info.weather.first?.description
        let maxTemp = String(info.main.temp_max)
        let minTemp = String(info.main.temp_min)
        let humidity = String(info.main.humidity)
        self.detailLabel.text = "The weather indicates \(descr ?? "") having maximum temperature rising upto \(maxTemp) and minimum temperature going down to \(minTemp) with humidity \(humidity)"
    }
}
