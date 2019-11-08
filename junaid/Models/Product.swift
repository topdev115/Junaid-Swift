//
//  Product.swift
//  junaid
//
//  Created by Administrator on 2019/10/27.
//  Copyright © 2019 Zemin Li. All rights reserved.
//
import Foundation

class Product {
    var id: Int = 0
    var categoryId: Int = 0
    var name: String = ""
    var sku: String = ""
    var gender: String = ""
    var quantity: String = ""
    var description: String = ""
    var topNote: String = ""
    var middleNote: String = ""
    var bottomNote: String = ""
    var note: String = ""
    var releaseDate: String = ""
    var categoryName: String = ""
    
    var countries: [Country] = []
    var images: [Image] = []
    
    var related: [Product] = []
   
    init(_ product : Dictionary<String, AnyObject>) {
        if let id = product["id"] as? String {
            self.id = Int(id)!
        }
        
        if let categoryId = product["category_id"] as? String {
            self.categoryId = Int(categoryId)!
        }
        
        if let name = product["name"] as? String {
            self.name = name
        }
        
        if let sku = product["sku"] as? String {
            self.sku = sku
        }
        
        if let gender = product["gender"] as? String {
            self.gender = gender
        }
        
        if let quantity = product["quantity"] as? String {
            self.quantity = quantity
        }
        
        if let description = product["description"] as? String {
            self.description = description
        }
        
        if let topNote = product["top_note"] as? String {
            self.topNote = topNote
        }
        
        if let middleNote = product["middle_note"] as? String {
            self.middleNote = middleNote
        }
        
        if let bottomNote = product["bottom_note"] as? String {
            self.bottomNote = bottomNote
        }
        
        self.note = "Top: \(self.topNote)  |  Heart: \(self.middleNote)  |  Bottom: \(self.bottomNote)"
        
        if let releaseDate = product["release_date"] as? String {
            self.releaseDate = releaseDate
        }
        
        if let categoryName = product["category_name"] as? String {
            self.categoryName = categoryName
        }
        
        if let countries = product["countries"] as? [Dictionary<String, AnyObject>] {
            for _country in countries {
                let newCountry = Country(_country)
                self.countries.append(newCountry)
            }
        }
        
        if let images = product["images"] as? [Dictionary<String, AnyObject>] {
            for _image in images {
                let newImage = Image(_image)
                self.images.append(newImage)
            }
        } else if let image = product["images"] as? Dictionary<String, AnyObject> {
            let newImage = Image(image)
            self.images.append(newImage)
        }
        
        if let related = product["related_products"] as? [Dictionary<String, AnyObject>] {
            for _related in related {
                let newRelated = Product(_related)
                self.related.append(newRelated)
            }
        }
    }
    
    /*
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
    
    static func ==(lhs: Product, rhs: Product) -> Bool {
        return lhs.id == rhs.id
    }
    */
}
