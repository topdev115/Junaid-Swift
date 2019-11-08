//
//  StoreDetailController.swift
//  junaid
//
//  Created by Administrator on 2019/10/30.
//  Copyright © 2019 Zemin Li. All rights reserved.
//

import UIKit

class StoreDetailController: UIViewController {
    @IBOutlet weak var shopNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var contactNumberLabel: UILabel!
    
    @IBOutlet weak var contactButton: UIView!
    @IBOutlet weak var directionButton: UIView!
    
    var store: Store!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationItem.title = store.city
        
        shopNameLabel.text = store.name
        addressLabel.text = store.address
        locationLabel.text = store.city + " " + store.country
        contactNumberLabel.text = store.contactNumber
        
        let tapContact = UITapGestureRecognizer(target: self, action: #selector(onContact))
        contactButton.addGestureRecognizer(tapContact)
        
        let tapDirection = UITapGestureRecognizer(target: self, action: #selector(onDirection))
        directionButton.addGestureRecognizer(tapDirection)
    }
    
    @objc func onContact() {
        if let url = URL(string: "tel://\(store.contactNumber)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @objc func onDirection() {
        let shareString = "Shop: \(store.name)\nAddress: \(store.address)\nLocation: \(store.city + " " + store.country)\nContact: \(store.contactNumber)\n"
        let items = [shareString]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)
    }
    
}
