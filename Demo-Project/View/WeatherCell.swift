//
//  WeatherCell.swift
//  Demo-Project
//
//  Created by Михаил Зайцев on 20.10.2021.
//

import UIKit
import Kingfisher

class WeatherCell: UICollectionViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    
    private var dateFormatter: DateFormatter = {
        let dt = DateFormatter()
        dt.dateFormat = "EEEE, HH:mm"
        return dt
    }()
    
    public func configure(with weather: Weather) {
        dateLabel.text = dateFormatter.string(from: weather.date)
        
        tempLabel.text = String(format: "%.0f℃", weather.temperature)
        
        let iconUrlString = "https://api.openweathermap.org/img/w/\(weather.icon).png"
        weatherIconImageView.kf.setImage(with: URL(string: iconUrlString))
    }
}
