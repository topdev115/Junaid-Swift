//
//  QuizInfoController.swift
//  junaid
//
//  Created by Administrator on 2019/11/11.
//  Copyright © 2019 Zemin Li. All rights reserved.
//

import UIKit

class QuizInfoController: UIViewController {
    @IBOutlet weak var infoLabel: UILabel!
    
    var infoText: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        infoLabel.text = infoText
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
