//
//  WeatherAlertViewController.swift
//  WeatherAlert
//
//  Created by Dan Durbaca on 09.10.2023.
//

import UIKit

class WeatherAlertViewController: UIViewController {

    enum Const {
        static let heightForRow: CGFloat = 80
    }
    
    @IBOutlet weak var weatherAlertTableView: UITableView!
    
    fileprivate let model = WeatherAlertViewModel()
    fileprivate let imageCacheService = ImageCacheService()

    let imageUrl = URL(string: "https://picsum.photos/1000")!
    var isDragging:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        model.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        model.updateWeatherAlerts()
    }
}

extension WeatherAlertViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.weatherAlerts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherAlertCellID", for: indexPath as IndexPath) as! WeatherAlertCell

        let alert = model.weatherAlerts[indexPath.row]
        cell.eventLabel.text = alert.properties.event_name
        cell.sourceLabel.text = alert.properties.source
        cell.setStarts(alert.properties.start_date)
        cell.setEnds(alert.properties.end_date)
        cell.thumbImageView.image = nil
        imageCacheService.setImage(key: String(indexPath.row), from: self.imageUrl, imageView: cell.thumbImageView)
        
        return cell
    }
}

extension WeatherAlertViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Const.heightForRow
    }
}

extension WeatherAlertViewController: WeatherAlertViewModelProtocol {    
    func didUpdateWeatherAlerts() {
        DispatchQueue.main.async {
            self.weatherAlertTableView.reloadData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.imageCacheService.purgeQueue()
            }
        }
    }
}

extension WeatherAlertViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(isDragging) {
            imageCacheService.purgeQueue()
        }
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isDragging = true
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        isDragging = false
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        imageCacheService.purgeQueue()
    }
}


