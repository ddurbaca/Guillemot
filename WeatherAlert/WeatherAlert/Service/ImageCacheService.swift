//
//  ImageCacheService.swift
//  WeatherAlert
//
//  Created by Dan Durbaca on 10.10.2023.
//

import UIKit

struct ImageCacheService {
    
    private func getSafeName(str:String) -> String {
        var invalidCharacters = CharacterSet(charactersIn: ":/")
        invalidCharacters.formUnion(.newlines)
        invalidCharacters.formUnion(.illegalCharacters)
        invalidCharacters.formUnion(.controlCharacters)

        return str
            .components(separatedBy: invalidCharacters)
            .joined(separator: "")
    }
    
    private func saveData(key:String, data: NSData) {
        let safeKey = getSafeName(str: key)
        let manager = FileManager.default
        do {
            let cacheFolderURL = try FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: false
            )
            let nestedFolderURL = cacheFolderURL.appendingPathComponent("WALERTFiles")

            try manager.createDirectory(
                    at: nestedFolderURL,
                    withIntermediateDirectories: false,
                    attributes: nil
                )
            let fileURL = nestedFolderURL.appendingPathComponent(safeKey)
            try data.write(to: fileURL)
        } catch {
            
        }
    }

    private func loadData(key:String) -> NSData? {
        let safeKey = getSafeName(str: key)
        do {
            let cacheFolderURL = try FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: false
            )
            let nestedFolderURL = cacheFolderURL.appendingPathComponent("WALERTFiles")
            let fileURL = nestedFolderURL.appendingPathComponent(safeKey)
            let dta = NSData(contentsOf: fileURL)
            
            return dta
        } catch {
            return nil
        }
    }
    
    func setImage(key: String, from url: URL, contentMode mode: UIImageView.ContentMode = .scaleAspectFit, imageView: UIImageView) {
        let queue = DispatchQueue(label: "com.dandurbaca.walertq", qos: .background)
        queue.async {
            if let img = AppDelegate.IMAGE_CACHE[key] {
                DispatchQueue.main.async() {
                    imageView.contentMode = mode
                    imageView.image = img
                }
            } else if let imgd = loadData(key: key) {
                let image = UIImage(data: imgd as Data)
                AppDelegate.IMAGE_CACHE[key] = image
                DispatchQueue.main.async() {
                    imageView.contentMode = mode
                    imageView.image = image
                }
            } else {
                AppDelegate.IMAGE_JOBS[imageView] = [key:url]
            }
        }
    }
    
    func purgeQueue() {
        for (imageView,prms) in AppDelegate.IMAGE_JOBS {
            if let p = prms.first {
                URLSession.shared.dataTask(with: p.value) { data, response, error in
                    _ = response as? HTTPURLResponse
                    if let d = data {
                        let image = UIImage(data: d)
                        AppDelegate.IMAGE_CACHE[p.key] = image
                        if loadData(key: p.key) != nil {
                            print("image already saved")
                        } else {
                            saveData(key: p.key, data: d as NSData)
                        }
                        DispatchQueue.main.async() {
                            //imageView.contentMode = mode
                            imageView.image = image
                        }
                    }
                }.resume()
            }
        }
        AppDelegate.IMAGE_JOBS = [:]
    }

}
