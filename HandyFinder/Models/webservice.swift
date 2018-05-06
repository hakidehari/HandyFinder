//
//  webservice.swift
//  HandyFinder
//
//  Created by Haki Dehari on 2/25/18.
//  Copyright © 2018 EpochApps. All rights reserved.
//

import Foundation

protocol WebServiceDelegate {
    func getUserData(user: User)
}

class WebService: NSObject {
    
    var userLoggedIn: User?
    
    let serviceURL = "http://192.168.64.2/handyman/webservice.php"
    
    let handyServiceURL = "http://192.168.64.2/handyman/handyservice.php"
    
    var delegate: WebServiceDelegate?
    
    /////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////
    
    //registers the user
    func register(finished: @escaping ((_ isSuccess: Bool) -> Void)) {
        let requestURL = NSURL(string: serviceURL)
        
        //creating NSMutableURLRequest
        let request = NSMutableURLRequest(url: requestURL! as URL)
        
        //setting the method to post
        request.httpMethod = "POST"
        
        //getting values from the user bject
        let firstName = newUser.firstName
        let lastName = newUser.lastName
        let email = newUser.email
        let state = newUser.state
        let city = newUser.city
        let password = newUser.password
        let zipCode = newUser.zipCode
        let isHMan = newUser.isHMan
        let skills = newUser.skills
        let experience = newUser.experience
        let latitude = newUser.latitude
        let longitude = newUser.longitude
        let login = "NO"
        
        let postParameters = "firstName="+firstName+"&lastName="+lastName+"&email="+email+"&state="+state+"&city="+city+"&password="+password+"&zipCode="+zipCode+"&isHMan="+isHMan+"&skills="+skills+"&experience="+experience+"&login="+login+"&latitude="+latitude+"&longitude="+longitude
        
        //adding the parameters to request body
        request.httpBody = postParameters.data(using: String.Encoding.utf8)
        
        
        //creating a task to send the post request
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            data, response, error in
            
            if error != nil{
                print("error is \(error!)")
                return;
            }
            
            //parsing the response
            do {
                //converting resonse to NSDictionary
                let myJSON =  try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                //parsing the json
                if let parseJSON = myJSON {
                    
                    //creating a string
                    var msg : String!
                    
                    //getting the json response
                    msg = parseJSON["message"] as! String?
                    
                    //printing the response
                    if msg == "successfully registered" {
                        self.userLoggedIn = User(firstName: firstName, lastName: lastName, email: email, state: state, city: city, password: "", password2: "", zipCode: zipCode, isHMan: isHMan, skills: skills, experience: experience, latitude: latitude, longitude: longitude)
                        self.delegate?.getUserData(user: self.userLoggedIn!)
                        print(msg)
                        finished(true)
                        
                    } else {
                        print(msg)
                        finished(false)
                    }
                    
                    return
                }
            } catch {
                print(error)
            }
            
        }
        //executing the task
        task.resume()
        
    }//end register()
    
    /////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////
    
    
    func login(finished: @escaping ((_ isSuccess: Bool) -> Void)){
        
        let requestURL = NSURL(string: serviceURL)
        
        //creating NSMutableURLRequest
        let request = NSMutableURLRequest(url: requestURL! as URL)
        
        //setting the method to post
        request.httpMethod = "POST"
        
        //getting values from the user bject
        let email = loginInfo["email"]
        let password = loginInfo["password"]
        let latitude = loginInfo["latitude"]
        let longitude = loginInfo["longitude"]
        let login = "YES"
        
        let postParameters = "email="+email!+"&password="+password!+"&login="+login+"&latitude="+latitude!+"&longitude="+longitude!
        
        //adding the parameters to request body
        request.httpBody = postParameters.data(using: String.Encoding.utf8)
        
        
        //creating a task to send the post request
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            data, response, error in
            
            if error != nil{
                print("error is \(error!)")
                return;
            }
            
            //parsing the response
            do {
                //converting response to NSDictionary
                let myJSON =  try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                //parsing the json
                if let parseJSON = myJSON {
                    
                    //creating a string
                    var msg : String!
                    var fName : String!
                    var lName: String!
                    var mail: String!
                    var zip: String!
                    var city: String!
                    var isHMan: String!
                    var skills: String!
                    var experience: String!
                    var state: String!
                    
                    //getting the json response
                    msg = parseJSON["message"] as! String?
                    fName = parseJSON["firstName"] as! String?
                    lName = parseJSON["lastName"] as! String?
                    mail = parseJSON["email"] as! String?
                    zip = parseJSON["zipCode"] as! String?
                    city = parseJSON["city"] as! String?
                    isHMan = parseJSON["isHMan"] as! String?
                    skills = parseJSON["skills"] as! String?
                    experience = parseJSON["experience"] as! String?
                    state = parseJSON["state"] as! String?
                    
                    
                    if msg == "login successful" {
                        self.userLoggedIn = User(firstName: fName, lastName: lName, email: mail, state: state, city: city, password: "", password2: "" , zipCode: zip, isHMan: isHMan, skills: skills, experience: experience, latitude: loginInfo["latitude"]!, longitude: loginInfo["longitude"]!)
                        self.delegate?.getUserData(user: self.userLoggedIn!)
                        finished(true)
                        print(msg)
                        
                        
                    } else {
                        finished(false)
                        print(msg)
                    }
                    return
                }
            } catch {
                print(error)
            }
            
        }
        //executing the task
        task.resume()
    }//end login()
    
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    //function that retrieves handymen within the users area
    func retrieveHandyMen(callback: @escaping (Array<AnyObject>) -> ()) {
        //declare return variable
        var handymen: Array<Any>!
        
        //getting the request ready
        let requestURL = NSURL(string: handyServiceURL)
        
        let request = NSMutableURLRequest(url: requestURL! as URL)
        
        request.httpMethod = "POST"
        
        let latitude = loginInfo["latitude"]
        let longitude = loginInfo["longitude"]
        
        let postParameters = "latitude="+latitude!+"&longitude="+longitude!
        
        request.httpBody = postParameters.data(using: String.Encoding.utf8)
        
        //starting the datatask
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil{
                print("error is \(error!)")
                return;
            }
            
            do {
                //parse through the JSON to retrieve an array of dictionaries
                let myJSON =  try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                if let parseJSON = myJSON {
                    
                    handymen = parseJSON["handymen"] as! Array?
                    
                    if handymen == nil {
                        callback([])
                    } else {
                        callback(handymen as! Array<AnyObject>)
                    }
                    
                    print(handymen)
                }
            } catch {
                print(error)
            }
        }
    
        task.resume()
        
    }//end function
    
   
    
}//end class
    
    

