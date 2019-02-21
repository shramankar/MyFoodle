//
//  donateOneViewController.swift
//  fooddle
//
//  Created by shraman kar on 1/2/19.
//  Copyright © 2019 shraman kar. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation
import CoreML
import Vision
//import PHPhotoLibrary

//import FirebaseDatabase
// import FirebaseStorage

class donateOneViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, CLLocationManagerDelegate, UISearchBarDelegate, UITextFieldDelegate {
    
    

 
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
    }
    var imgurl: String?
    var imageURL : URL?
    var imgName : String?
    var downURL : String?
    enum ImageSource {
        case photoLibrary
        case camera
    }
    
    @IBOutlet weak var myImageView: UIImageView!
    
    @IBOutlet weak var nameText: UITextField!
    
    @IBOutlet weak var pickText: UITextField!
    @IBOutlet weak var adressText: UITextField!
    let locationManager = CLLocationManager()
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        self.nameText.delegate = self
        self.adressText.delegate = self
        self.pickText.delegate = self
        
}
    // hide keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return(true)
    }
    func locationManager(_ locationManager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locat = locationManager.location
        let geocoder: CLGeocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(locat!, completionHandler: {
            (placemarks, error) in
            if (error != nil) {
                //geocoding failed
            } else {
                let pm = placemarks! as [CLPlacemark]
                
                if pm.count > 0 {
                    let pm = placemarks![0]
                    
                    var address = ""
                     if (pm.subThoroughfare != "") {
                        address = pm.subThoroughfare!+" "
                    }
                    if (pm.thoroughfare != "") {
                        address = address + pm.thoroughfare! + ","
                    }
                    if (pm.locality != "") {
                        address = address + pm.locality! + " "
                    }
                    if (pm.administrativeArea != "") {
                        address = address + pm.administrativeArea! + " "
                    }
                    if (pm.postalCode != "") {
                        address = address + pm.postalCode!
                    }
                   
                    self.adressText.text = address
                    locationManager.stopUpdatingLocation()
                }
            }
        })
        // Do any additional setup after loading the view.
    }
    //MARK: Take Image by Camera
    @IBAction func camera(_ sender: Any) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            selectImageFrom(.photoLibrary)
            return
        }
        selectImageFrom(.camera)
        guard let selectedImage = myImageView.image else {
            print("Image not found!")
            return
        }
        UIImageWriteToSavedPhotosAlbum(selectedImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    func selectImageFrom(_ source: ImageSource){
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        
        switch source {
        case .camera:
            imagePicker.sourceType = .camera
        case .photoLibrary:
            imagePicker.sourceType = .photoLibrary
        }
        present(imagePicker, animated: true, completion: nil)
    }
    
    //MARK: - Saving Image here
    @IBAction func save(_ sender: AnyObject) {
        guard let selectedImage = myImageView.image else {
            print("Image not found!")
            return
        }
        UIImageWriteToSavedPhotosAlbum(selectedImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    //MARK: - Add image to Library
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            showAlertWith(title: "Save error", message: error.localizedDescription)
        } else {
            showAlertWith(title: "Saved!", message: "Your image has been saved to your photos.")
        }
    }
    
    func showAlertWith(title: String, message: String){
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }



    
    @IBAction func importImage(_ sender: Any) {
        //if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary)
       // {
            let image = UIImagePickerController()
            image.delegate = self
            image.sourceType = UIImagePickerController.SourceType.photoLibrary
            image.allowsEditing = false
            
            self.present(image, animated: true)
                {
                    //what you want to do with Image(not requiered)
                }
       // } else {
            // If Camera
      //  }
  }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        imageURL = info[UIImagePickerController.InfoKey.imageURL] as? URL
        if imageURL == nil {
            print ("Image not found")
        } else {
            imgName = imageURL!.lastPathComponent
        }
       
        guard let selectedImage = info[.originalImage] as? UIImage else {
            print("Image not found!")
            return
        }
        
        myImageView.image = selectedImage
        
        guard let ciimage = CIImage(image: selectedImage)else{
            fatalError("COuld not convert to CIIMage")
        }
        if imagePicker != nil{
            imagePicker.dismiss(animated: true, completion: nil)

        }
        detect(image: ciimage)
    }
  
    
    
    func detect(image:CIImage){
        
       guard let model = try? VNCoreMLModel(for: Inceptionv3().model)else{
            fatalError("LOADING CORE ML MODel failed")
        }
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation]else{
                fatalError("failed to process image")
            }
            print ("Result is description: \(results[0].identifier)")
            self.nameText.text = results[0].identifier
        }
        let handler = VNImageRequestHandler(ciImage: image)
        do{
        try handler.perform([request])
        }
        catch{
            print(error)
        }
    }
    
    @IBAction func danateBut(_ sender: Any) {
        // Get a reference to the storage service using the default Firebase App
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        if imageURL == nil {
            let data = Data(myImageView.image!.jpegData(compressionQuality: 0.8)!)
            
            //let data = Data()
            
            let cameraImageUploadRef = storageRef.child("camera\(self.nameText.text!).jpg")
            let uploadTask = cameraImageUploadRef.putData(data, metadata: nil) { (metadata, error) in
                guard let metadata = metadata else {
                   
                    return
                }
                // Metadata contains file metadata such as size, content-type.
                let size = metadata.size
                print ("Size of Camera Pic uploaded is \(size))")
                // You can also access to download URL after upload.
                cameraImageUploadRef.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                   
                        return
                    }
                    let downURL = downloadURL.absoluteString
                    //print ("downloadURL is \(downloadURL)")
                    // if self.downURL != nil {
                    print ("downURL is is \(downURL)")
                    
                   
                    let collection = Firestore.firestore().collection("DonationDetails")
                    let donationDictionary = ["Food" : self.nameText.text!,
                                              "Instruction": self.pickText.text!,
                                              "DateTimeAdded": Date().description,
                                              "UserEmail": (Auth.auth().currentUser?.email)!,
                                              "CompleteAddress" : self.adressText.text!,
                                              "PictureURL": downURL, "isAvailable": "true"]
                    collection.addDocument(data: donationDictionary )
                    
                    
                }
            }
        } else {
        let foodImageRef = storageRef.child("foodImages/\(imgName!)")

        foodImageRef.putFile(from: imageURL!, metadata: nil) { metadata, error in
            guard let metadata = metadata else {
             
                return
            }
            // Metadata contains file metadata such as size, content-type.
            let size = metadata.size
            // You can also access to download URL after upload.
            print ("Size is \(size/1000000) MB")
            foodImageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    
                    return
                }
               let downURL = downloadURL.absoluteString
            
                    print ("downURL is is \(downURL)")

                
                    let collection = Firestore.firestore().collection("DonationDetails")
                let donationDictionary = ["Food" : self.nameText.text!,
                                          "Instruction": self.pickText.text!,
                                          "DateTimeAdded": Date().description,
                                          "UserEmail": (Auth.auth().currentUser?.email)!,
                                          "CompleteAddress" : self.adressText.text!,
                                          "PictureURL": downURL,"isAvailable": "true"]
                    collection.addDocument(data: donationDictionary )
                    
                
            }
            
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



    

