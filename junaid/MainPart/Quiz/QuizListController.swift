//
//  QuizListController.swift
//  junaid
//
//  Created by Administrator on 2019/11/11.
//  Copyright © 2019 Zemin Li. All rights reserved.
//

import UIKit

class QuizListController: UITableViewController {

    private var quizList: [QuizListItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        quizList.append(QuizListItem(id: 1, name: "Related Products Quiz", type: "related_product"))
        quizList.append(QuizListItem(id: 2, name: "Products Quiz", type: "product"))
        quizList.append(QuizListItem(id: 3, name: "Sales Pitch Quiz", type: "sales_pitch"))
        quizList.append(QuizListItem(id: 4, name: "Monthly Quiz", type: "monthly"))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueQuiz", let quizVC = segue.destination as? QuizController {
            quizVC.quizType = quizList[(sender as! IndexPath).row]
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "segueQuiz", sender: indexPath)
    }
}
