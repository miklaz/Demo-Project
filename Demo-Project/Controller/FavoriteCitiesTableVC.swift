//
//  FavoriteCitiesTableVC.swift
//  Demo-Project
//
//  Created by Михаил Зайцев on 20.10.2021.
//

import UIKit
import RealmSwift

class FavoriteCitiesTableVC: UITableViewController {

    var cities: Results<City>?
    var notificationToken: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cities = try? RealmService.get(City.self)
        notificationToken = cities?.observe { [weak self] changes in
            guard let self = self else { return }
            switch changes {
            case .initial:
                break
            case let .update(_, deletions, insertions, modifications):
                self.tableView.beginUpdates()
                self.tableView.deleteRows(at: deletions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                self.tableView.insertRows(at: insertions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                self.tableView.reloadRows(at: modifications.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                self.tableView.endUpdates()
            case .error(let error):
                print(error)
            }
        }

    }
    
    deinit {
        notificationToken?.invalidate()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //получаем ячейку из пула
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath) as? CityCell, let city = cities?[indexPath.row] else {
            preconditionFailure("CityCell cannot be dequeued")
        }
        //получаем город для конкретной строки
        let cityname = city.name
        //устанавливаем город в надпись ячейки
        cell.cityNameLabel.text = cityname

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //переход на следующий контроллер
        performSegue(withIdentifier: "Show Forecast", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //подготовока к вереходу
        if segue.identifier == "Show Forecast",
           let destinationVC = segue.destination as? ForecastCollectionVC,
           let indexPath = tableView.indexPathForSelectedRow,
           let city = cities?[indexPath.row] {
            let cityname = city.name
            //передача города на следующий контроллер
            destinationVC.cityname = cityname
            destinationVC.title = cityname
        }
    }
    
    //кнопка для добавления городов
    @IBAction func addCityButton(_ sender: Any) {
        //подготовка и показ alert
        let alertVc = UIAlertController(title: "Enter city name", message: nil, preferredStyle: .alert)
        alertVc.addTextField(configurationHandler: nil)
        let okAction = UIAlertAction(title: "Ok", style: .default) { [weak self] _ in
            guard let name = alertVc.textFields?[0].text else { return }
            self?.createCity(named: name)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertVc.addAction(okAction)
        alertVc.addAction(cancelAction)
        present(alertVc, animated: true, completion: nil)
    }
    
    //сохранение города в Realm
    private func createCity(named cityname: String) {
        let city = City(name: cityname)
        try? RealmService.save(items: [city])
    }


}
