//
//  Store.swift
//  junaid
//
//  Created by Administrator on 2019/10/24.
//  Copyright © 2019 Zemin Li. All rights reserved.
//

class Store {
    var id: Int = 0
    var name: String = ""
    var address: String = ""
    var mapUrl: String = ""
    var latitude: String = ""
    var longitude: String = ""
    var countryId: Int = 0
    var country: String = ""
    var cityId: Int = 0
    var city: String = ""
    var contactNumber: String = ""
    
    init(_ store : Dictionary<String, AnyObject>) {
        if let id = store["id"] as? String {
            self.id = Int(id)!
        } else if let id = store["id"] as? Int {
            self.id = id
        }
        
        if let name = store["name"] as? String {
            self.name = name
        }
        
        if let address = store["address"] as? String {
            self.address = address
        }
        
        if let mapUrl = store["map_url"] as? String {
            self.mapUrl = mapUrl
        }
        
        if let latitude = store["lat"] as? String {
            self.latitude = latitude
        }
        
        if let longitude = store["lng"] as? String {
            self.longitude = longitude
        }
        
        if let countryId = store["country_id"] as? String {
            self.countryId = Int(countryId)!
        }
        
        if let country = store["country"] as? String {
            self.country = country
        }
        
        if let cityId = store["city_id"] as? String {
            self.cityId = Int(cityId)!
        }
        
        if let city = store["city"] as? String {
            self.city = city
        }
        
        if let contactNumber = store["contact_number"] as? String {
            self.contactNumber = contactNumber
        }
    }
}

class City {
    var id: Int = 0
    var name: String = ""
    var stores: [Store] = []

    init(_ city : Dictionary<String, AnyObject>) {
        if let id = city["id"] as? Int {
            self.id = id
        }
        
        if let name = city["city_name"] as? String {
            self.name = name
        }
        
        if let stores = city["stores"] as? [Dictionary<String, AnyObject>] {
            for _store in stores {
                let newStore = Store(_store)
                self.stores.append(newStore)
            }
        }
    }
}
