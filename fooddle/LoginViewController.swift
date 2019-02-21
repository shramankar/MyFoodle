//
//  LoginViewController.swift
//  fooddle
//
//  Created by shraman kar on 1/1/19.
//  Copyright © 2019 shraman kar. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func logBut(_ sender: Any) {
        Auth.auth().signIn(withEmail : emailText.text! , password : passwordText.text!) {(user,error) in
                if error != nil{
                    
                    print(error!)
                   
                    let alert = UIAlertView()
                    alert.title = "Login Error"
                    alert.message = error!.localizedDescription
                    alert.addButton(withTitle: "Ok")
                    alert.show()
                    
                    
                }else{
                 self.performSegue(withIdentifier: "FromLoginToDashboard", sender: self)
                    print("ya")
                }
            
        }
        
    }
    func work(){
        print("worked")
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
