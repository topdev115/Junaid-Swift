//
//  Country.swift
//  junaid
//
//  Created by Administrator on 2019/10/24.
//  Copyright © 2019 Zemin Li. All rights reserved.
//
import UIKit

class Country {
    var id: Int = 0
    var name: String = ""
    var icon: String = ""
    var iconUrl: URL?
    var currency: String = ""
    var price: String = ""
    
    init(_ country : Dictionary<String, AnyObject>) {
        if let id = country["id"] as? Int {
            self.id = id
        }
        
        if let name = country["name"] as? String {
            self.name = name
        }
        
        if let icon = country["icon"] as? String {
            self.icon = icon
            self.iconUrl = URL(string: Constants.API.MAIN_URL + "/" + self.icon)!
        }
        
        if let currency = country["currency"] as? String {
            self.currency = currency
        }
        
        if let price = country["price"] as? String {
            self.price = price
        }
    }
}
