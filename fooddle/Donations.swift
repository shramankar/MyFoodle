//
//  Donations.swift
//  fooddle
//
//  Created by shraman kar on 1/7/19.
//  Copyright © 2019 shraman kar. All rights reserved.
//

import Foundation
import Firebase

class Donation {
    var Food: String = ""
    var Instruction: String = ""
    var DateTimeAdded: String = ""
    var UserEmail : String = ""
    var CompleteAddress : String = ""
    var PictureURL : String = ""
    var isAvailable : String = ""
    
    init(food:String,instr: String,date : String, email: String,address : String, picurl : String ){
        Food = food
        Instruction = instr
        DateTimeAdded = date
        UserEmail = email
        CompleteAddress = address
        PictureURL = picurl
        isAvailable = "true"
    }
}




