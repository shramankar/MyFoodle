//
//  RegisterViewController.swift
//  fooddle
//
//  Created by shraman kar on 1/1/19.
//  Copyright © 2019 shraman kar. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
   /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        var myString = String()
        var second = segue.destination as! ViewController
        //second.myString = emailText.text!
    }
*/
  
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func regBut(_ sender: Any) {
  
        
        Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { (user, error) in
            if error != nil{
                let alert = UIAlertView()
                alert.title = "Registration Error"
                alert.message = error?.localizedDescription
                
                alert.addButton(withTitle: "Ok")
                alert.show()
                
                print("wrong\(error!)")
            }else{
                self.performSegue(withIdentifier: "foddleDashBoard", sender: self)
                print("Registration Successful!!")

              }
            
    }
        
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


