//
//  WeatherAlertCell.swift
//  WeatherAlert
//
//  Created by Dan Durbaca on 10.10.2023.
//

import UIKit

class WeatherAlertCell: UITableViewCell {
    
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var eventLabel: UILabel!
    @IBOutlet weak var startsLabel: UILabel!
    @IBOutlet weak var endsLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!

    var startDate, endDate:Date?
    let dateFormatter = DateFormatter()

    func setStarts(_ d:String) {
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
        if let date = dateFormatter.date(from: d) {
            self.startDate = date
            startsLabel.text = date.formatted()
            setDuration()
        }
    }
    
    func setEnds(_ d:String?) {
        if let dt = d {
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
            if let date = dateFormatter.date(from: dt) {
                self.endDate = date
                self.endsLabel.text = date.formatted()
                setDuration()
            }
        } else {
            endsLabel.text = "N/A"
        }
    }

    func setDuration() {
        guard let start = self.startDate, let end = self.endDate else {
            durationLabel.text = "N/A"
            return
        }
        
        let diff = Int(end.timeIntervalSince1970 - start.timeIntervalSince1970)
        let hours = diff / 3600
        let minutes = (diff - hours * 3600) / 60
               
        durationLabel.text = String(minutes) + " m"
    }
}
