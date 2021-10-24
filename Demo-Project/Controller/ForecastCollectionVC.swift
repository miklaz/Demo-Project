//
//  ForecastCollectionVC.swift
//  Demo-Project
//
//  Created by Михаил Зайцев on 20.10.2021.
//

import UIKit
import Alamofire
import RealmSwift

class ForecastCollectionVC: UICollectionViewController {
    
    public var cityname: String = ""
    private lazy var weathers: Results<Weather> = try! RealmService.get(Weather.self).filter("date >= %@", Date()).filter("id CONTAINS[cd] %@", self.cityname).sorted(byKeyPath: "id")
    private var notificationToken: NotificationToken?
    private let networkService = NetworkService()
    
    
    override func viewDidLoad() {
        //загрузка данных из сети
        networkService.forecast(for: cityname) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(weathers):
                
                let city = City(name: self.cityname, weathers: weathers)
                try? RealmService.save(items: [city])
                
            case let .failure(error):
                self.show(error: error)
            }
        }
        title = cityname
        
        //загрузка данных из realm
        notificationToken = weathers.observe { changes in
            switch changes {
            case .initial, .update:
                self.collectionView.reloadData()
            case .error(let error):
                print(error)
            }
        }
    }
    

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return weathers.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCell", for: indexPath) as? WeatherCell else { preconditionFailure() }
        //конфигруция ячейки
        cell.layer.borderColor = UIColor.systemGray2.cgColor
        cell.layer.borderWidth = 2
        cell.layer.cornerRadius = 20
        
        let weather = weathers[indexPath.row]
        cell.configure(with: weather)
        
        
        return cell
    }

}
