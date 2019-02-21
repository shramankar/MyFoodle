//
//  WelcomeViewController.swift
//  fooddle
//
//  Created by shraman kar on 1/19/19.
//  Copyright © 2019 shraman kar. All rights reserved.
//

import UIKit
import Firebase
class WelcomeViewController: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        if (Auth.auth().currentUser?.email  !=  nil) {
            let newViewController = DashboardViewController()
            self.navigationController?.pushViewController(newViewController, animated: true)
            performSegue(withIdentifier: "FromWelcomeToDashboard", sender: self)
            print("User logged in is \(Auth.auth().currentUser?.email)")
        }
    }
  
    override func viewDidLoad() {
       
        // Do any additional setup after loading the view.
        super.viewDidLoad()
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
