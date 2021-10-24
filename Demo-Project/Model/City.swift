//
//  City.swift
//  Demo-Project
//
//  Created by Михаил Зайцев on 20.10.2021.
//

import UIKit
import RealmSwift

class City: Object {
    @objc dynamic var name: String = ""
    let weathers = List<Weather>()
    
    convenience init(name: String, weathers: [Weather] = []) {
        self.init()
        
        self.name = name
        self.weathers.append(objectsIn: weathers)
    }
    
    override class func primaryKey() -> String? {
        return "name"
    }
}
