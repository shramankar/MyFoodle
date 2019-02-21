//
//  thankYouViewController.swift
//  fooddle
//
//  Created by shraman kar on 2/13/19.
//  Copyright © 2019 shraman kar. All rights reserved.
//

import UIKit
import Social
class thankYouViewController: UIViewController {

    @IBAction func shrare(_ sender: Any)
    {
    //Define the alert that will come once share button is clicked
    let alert = UIAlertController(title: "Share", message: "You can share what you donated, and how you like the app", preferredStyle: .actionSheet)
        //actions
        let actionOne = UIAlertAction(title: "Share on facebook", style: .default) { (UIAlertAction) in
            
            //If user hac facebook
            if SLComposeViewController.isAvailable(forServiceType:  SLServiceTypeFacebook){
                let post = SLComposeViewController(forServiceType: SLServiceTypeFacebook)!
                post.setInitialText("You can write a rivew or you can shar tha you donated something")
                post.add(UIImage(named: "FoodleLogo1"))
                self.present(post, animated: true, completion: nil)

            }else{
     
                    
                    let alert = UIAlertView()
                    alert.title = "Error"
                    alert.message = "Could not connect you withh facebook"
                    alert.addButton(withTitle: "Ok")
                    alert.show()
                    
                
            }

       
        }
        let actionTwo = UIAlertAction(title: "Share on twiter", style: .default) { (UIAlertAction) in
            
            //If user hac facebook
            if SLComposeViewController.isAvailable(forServiceType:  SLServiceTypeTwitter){
                let post = SLComposeViewController(forServiceType: SLServiceTypeTwitter)!
                post.setInitialText("You can write a rivew or you can shar tha you donated something")
                post.add(UIImage(named: "FoodleLogo1"))
                self.present(post, animated: true, completion: nil)
                
            }else{
                
                
                let alert = UIAlertView()
                alert.title = "Error"
                alert.message = "Could not connect you with Twiter"
                alert.addButton(withTitle: "Ok")
                alert.show()
                
                
            }
            
        }
        
        let actionThree = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        
        //Add action one to alert.actionSheert
        alert.addAction(actionTwo)
        alert.addAction(actionOne)
        alert.addAction(actionThree)
        self.present(alert, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

 
}
