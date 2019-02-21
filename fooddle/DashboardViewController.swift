//
//  DashboardViewController.swift
//  fooddle
//
//  Created by shraman kar on 1/1/19.
//  Copyright © 2019 shraman kar. All rights reserved.
//

import UIKit
import Firebase
class DashboardViewController: UIViewController {

    @IBOutlet weak var userInfo: UILabel!
    
    
    override func viewDidLoad() {
        
        
        userInfo.text = Auth.auth().currentUser?.email
        super.viewDidLoad()
       
        // Do any additional setup after loading the view.
    }
    
    @IBAction func logoutBut(_ sender: Any) {
        do{
            try Auth.auth().signOut()
            userInfo.text = "Bye"
        }
        catch{
            print("Error")
            userInfo.text = "Bye with error"

        }

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
