//
//  findTwoViewController.swift
//  fooddle
//
//  Created by shraman kar on 1/14/19.
//  Copyright © 2019 shraman kar. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications
class findTwoViewController: UIViewController {

    let notifId = "myNotif"
    @IBOutlet var nameOfFood: UILabel!
    
    @IBOutlet weak var imageOfFood: UIImageView!
    
    @IBOutlet weak var adressOfFood: UILabel!
    
    @IBOutlet weak var foodPlacement: UILabel!
    
    var donationArray : [Donation] = [Donation]()
    
    var segueString = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound , .badge], completionHandler: {didAllow, error in
            
        })
        retrieveDonationDetails()
        
        print ("segueString is \(segueString)")
      //nameOfFood.text = donationDictionary

        // Do any additional setup after loading the view.
    }

    @IBAction func notification(_ sender: Any) {
        scheduleNotification()
        print("pressed")
        
    }
    func scheduleNotification(){
        let localNotification = UNMutableNotificationContent()
        localNotification.body = adressOfFood.text ?? "not found"
        localNotification.title = "Fooddle"
        localNotification.sound = .default
        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
        let request = UNNotificationRequest(identifier: notifId, content: localNotification, trigger: notificationTrigger )
        UNUserNotificationCenter.current().add(request) { (error) in
            if error != nil{
                print("Notification Failed")
                return
            }else{
                print("Notification succse")
            }
        }
    }
    
    
    
    
    func retrieveDonationDetails(){
        
        let placeRef = Firestore.firestore().collection("DonationDetails").document(segueString)
            
            //.whereField("documentID", isEqualTo: segueString)
        
    
        
        placeRef.getDocument { (snapshot, error) in
            guard let snapshot = snapshot else {
                print("Error \(error!)")
                return
            }
            
            
                let docId = snapshot.documentID
                self.nameOfFood.text = (snapshot.get("Food") as! String)
                let url = URL(string: snapshot.get("PictureURL") as! String)
                let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                if data != nil {
                    self.imageOfFood.image = UIImage(data: data!)
                    self.imageOfFood.autoresizingMask = UIView.AutoresizingMask(rawValue: UIView.AutoresizingMask.flexibleBottomMargin.rawValue | UIView.AutoresizingMask.flexibleHeight.rawValue | UIView.AutoresizingMask.flexibleRightMargin.rawValue | UIView.AutoresizingMask.flexibleLeftMargin.rawValue | UIView.AutoresizingMask.flexibleTopMargin.rawValue | UIView.AutoresizingMask.flexibleWidth.rawValue)
                    self.imageOfFood.contentMode = UIView.ContentMode.scaleAspectFit
                    print ("Image found")
                }
                self.adressOfFood.text = (snapshot.get("CompleteAddress") as! String)
                self.foodPlacement.text = (snapshot.get("Instruction") as! String)
             //   let UserEmail = document.get("UserEmail") as! String
                
              print ("doc ID is \(docId)")
                
            
            
        }
        
    }

    @IBAction func pickup(_ sender: Any) {
        let placeRef = Firestore.firestore().collection("DonationDetails").document(segueString)
        placeRef.setData(["isAvailable":"false"], merge: true)
        performSegue(withIdentifier: "backToSearch", sender: nil)
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
