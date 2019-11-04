//
//  CityCellTableViewCell.swift
//  WeatherApp
//
//  Created by Vidya on 04/11/19.
//  Copyright © 2019 Vidyaprasad. All rights reserved.
//

import UIKit

class CityCell: UITableViewCell {

    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func updateCell(with data: CityDetail) {
        self.nameLabel.text = data.name
        self.countryLabel.text = data.country
    }

}
