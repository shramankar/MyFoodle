//
//  myDonationsViewController.swift
//  fooddle
//
//  Created by shraman kar on 1/20/19.
//  Copyright © 2019 shraman kar. All rights reserved.
//

import UIKit
import Firebase


class myDonationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {


        
        
        // Declare instance variables here
        var docIDArray : [String] = []
        var donationArray : [Donation] = [Donation]()
    
        // We've pre-linked the IBOutlets
        
    
    @IBOutlet weak var donateTabView: UITableView!
    
        override func viewDidLoad() {
            super.viewDidLoad()
            
            
          
            // map.showsUserLocation = true
            
            // locationManager(locationManager: CLLocationManager,  locations: [CLLocation])
            
            donateTabView.delegate = self
            donateTabView.dataSource = self
            donateTabView.register(UINib(nibName: "donationCell", bundle: nil) , forCellReuseIdentifier: "donationCell")
            
            //    let tapGesture = UITapGestureRecognizer(target: self, action: #selector (tableViewTapped))
            
            // donateTabView.addGestureRecognizer(tapGesture)
            
            
            configureTableView()
            
            
            retrieveMessages()
            
            donateTabView.separatorStyle = .singleLine
            
        }
        var myIndex = 0
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            myIndex = indexPath.row
            
            print("docIDArray[myIndex] is \(docIDArray[myIndex])")
            
            
            
            performSegue(withIdentifier: "FromMydonationsToDonationDetails", sender: self)
        }
        
        
        //MARK: - TableView Delegate Methods
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "donationCell", for: indexPath) as! donationCell
            //cell.donorEmail.text = docID
            cell.foodName.text = donationArray[indexPath.row].Food
            cell.foodAddress.text  = donationArray[indexPath.row].CompleteAddress
            //cell.avatarImageView.image = UIImage(named: "egg")
            let url = URL(string: donationArray[indexPath.row].PictureURL)
            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            
            if data != nil {
                cell.foodPic.image = UIImage(data: data!)
                print ("Image found")
                
            }
                
            else {
                print ("Image Load failed")}
            
            cell.foodPic.backgroundColor = UIColor.white
            cell.bgImage.backgroundColor = UIColor.white
            
            
            return cell
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
            
            return donationArray.count
            
            
        }
        
        // @objc func tableViewTapped() {
        // messageTextfield.endEditing(true)
        //  }
        
        override func prepare (for segue: (UIStoryboardSegue?), sender: Any?) {
            if (segue!.identifier == "FromMydonationsToDonationDetails") {
                let secondViewController = segue!.destination  as! findTwoViewController
                // let segueString = (sender as! String)
                secondViewController.segueString = docIDArray[myIndex]
            }
        }
        
        //TODO: Declare configureTableView here:
        
        func configureTableView() {
            donateTabView.rowHeight = UITableView.automaticDimension
            donateTabView.estimatedRowHeight = 200.0
            
            
        }
        
        
        
        
        //MARK: - TextField Delegate Methods
        
        
        
        ///////////////////////////////////////////
        
        
        //MARK: - Send & Recieve Messages from Firebase
        
        
        
        
        
        func retrieveMessages() {
            Firestore.firestore().collection("DonationDetails")
                .addSnapshotListener(includeMetadataChanges: true) { querySnapshot, error in
                    guard let snapshot = querySnapshot else {
                        print("Error retreiving snapshot: \(error!)")
                        return
                    }
                    
                    for diff in snapshot.documentChanges {
                        if diff.type == .added {
                            print("New city: \(diff.document.data())")
                        }
                    }
                    
                    let source = snapshot.metadata.isFromCache ? "local cache" : "server"
                    print("Metadata: Data fetched from \(source)")
            }
            let loggedInUser = Auth.auth().currentUser?.email as! String
            let placeRef = Firestore.firestore().collection("DonationDetails").whereField("isAvailable", isEqualTo: "true").whereField("UserEmail", isEqualTo: loggedInUser)
            placeRef.getDocuments { (snapshot, error) in
                guard let snapshot = snapshot else {
                    print("Error \(error!)")
                    return
                }
                
                for document in snapshot.documents {
                    let docID = document.documentID
                    let Food = document.get("Food") as! String
                    let DateTimeAdded = document.get("DateTimeAdded") as! String
                    let UserEmail = document.get("UserEmail") as! String
                    let PictureURL = document.get("PictureURL") as! String
                    let address = document.get("CompleteAddress") as! String
                    let instruction = document.get("Instruction") as! String
                    
                    
                    let donation = Donation(food: Food, instr: instruction, date: DateTimeAdded, email: UserEmail, address: address,picurl: PictureURL )
                    
                    
                    
                    self.donationArray.append(donation)
                    self.docIDArray.append(docID)
                    // print ("donationArray[indexPath.row].Food\(self.donationArray[self.donationArray.count-1].Food)")
                    // print (" donation.Food \(donation.Food)")
                    self.configureTableView()
                    self.donateTabView.reloadData()
                    //self.locationManager.stopUpdatingLocation()
                    
                }
                
            }
            
        }
        ////////////////////////////////////////////////
        
        //MARK - Log Out Method
        
        /*
         @IBAction func logOutPressed(_ sender: Any) {
         
         do {
         try Auth.auth().signOut()
         
         navigationController?.popToRootViewController(animated: true)
         
         }
         catch {
         print("error: there was a problem logging out")
         }
         
         }
         */
        
    
        
}
