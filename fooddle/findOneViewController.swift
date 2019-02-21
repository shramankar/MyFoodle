
import UIKit
import Firebase
import CoreLocation
import MapKit

class findOneViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, CLLocationManagerDelegate, UISearchBarDelegate {

    // Declare instance variables here
    var docIDArray : [String] = []
    var donationArray : [Donation] = [Donation]()
    let locationManager = CLLocationManager()
    
    // We've pre-linked the IBOutlets
    
    @IBOutlet weak var map: MKMapView!
    
    
    @IBOutlet weak var donateTabView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
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
    @IBAction func searchMap(_ sender: Any) {
        
     let searchControler = UISearchController(searchResultsController: nil)
        searchControler.searchBar.delegate = self
        present(searchControler, animated: true, completion: nil)
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
       
       //ignoring user
        UIApplication.shared.beginIgnoringInteractionEvents()
        //Activvity Indicator
        let activity = UIActivityIndicatorView()
        activity.style = UIActivityIndicatorView.Style.gray
        activity.center = self.view.center
        activity.hidesWhenStopped = true
        activity.startAnimating()
        self.view.addSubview(activity)
        //hide search bar
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
            //Create the search bar request
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchBar.text
        let activeSearch = MKLocalSearch(request: searchRequest)
        activeSearch.start { (response, error) in
            activity.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()

            if response == nil{
            let alert = UIAlertView()
            alert.title = "Adress not found"
            alert.message = error!.localizedDescription
            alert.addButton(withTitle: "Ok")
            alert.show()
                print("error")
                
                
            }else{
                
            
                
            
                let latitude = response?.boundingRegion.center.latitude
                let longitude = response?.boundingRegion.center.longitude
                
                let annotation = MKPointAnnotation()
                annotation.title = searchBar.text
                annotation.coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
                self.map.addAnnotation(annotation)
            }
        }
        
    }
    var myIndex = 0
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myIndex = indexPath.row
        
        print("docIDArray[myIndex] is \(docIDArray[myIndex])")
        
        
        
        performSegue(withIdentifier: "sege", sender: self)
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
            // cell.foodPic.image = UIImage(contentsOfFile: "City-No-Camera-icon.png")
            print ("Image Load failed")}
        
        // cell.foodPic.backgroundColor = UIColor.blue
        //cell.bgImage.backgroundColor = UIColor.white
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return donationArray.count
        
        
    }
    
    // @objc func tableViewTapped() {
    // messageTextfield.endEditing(true)
    //  }
    
    override func prepare (for segue: (UIStoryboardSegue?), sender: Any?) {
        if (segue!.identifier == "sege") {
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
        
        let placeRef = Firestore.firestore().collection("DonationDetails").whereField("isAvailable", isEqualTo: "true")
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print ("Entered locationManager")
        
        
        let location = locations[0]
        
        let span : MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        //self.map.setRegion(region, animated: true)
        self.map.showsUserLocation = true
        
        var locations = [MKPointAnnotation]()
        
        
        for item in donationArray {
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(item.CompleteAddress, completionHandler: {(placemarks, error) -> Void in
                if((error) != nil){
                    print("Error", error)
                }
                if let placemark = placemarks?.first {
                    
                    let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                    
                    let dropPin = MKPointAnnotation()
                    
                    dropPin.coordinate = coordinates
                    dropPin.title = item.CompleteAddress
                    
                    self.map.addAnnotation(dropPin)
                    self.map.selectAnnotation( dropPin, animated: true)
                    
                    locations.append(dropPin)
                    //add this if you want to show them all
                    self.map.showAnnotations(locations, animated: true)
                    self.locationManager.stopUpdatingLocation()
                }
            })
        }
        
        
        
    }
    
    
}



