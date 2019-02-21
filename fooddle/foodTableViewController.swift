//
//  foodTableViewController.swift
//  fooddle
//
//  Created by shraman kar on 2/9/19.
//  Copyright © 2019 shraman kar. All rights reserved.
//

import UIKit
import Firebase
class foodTableViewController: UITableViewController {
    var array = ["Canned Meat or Fish", "Soup", "Canned Fruits and Vegetables","Peanut Butter","Pasta","Milk Products","Grain Products","Cereal","Baby Food"
       
        
]

    override func viewDidLoad() {
        super.viewDidLoad()

      
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    // Putting the name in the cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"neededFood", for: indexPath)
        cell.textLabel?.text = array[indexPath.row]
        return cell
    }


   
}
