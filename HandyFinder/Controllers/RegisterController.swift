//
//  RegisterController.swift
//  HandyFinder
//
//  Created by Haki Dehari on 2/24/18.
//  Copyright © 2018 EpochApps. All rights reserved.
//

import UIKit
import Foundation
import CoreData

var newUser = User()

class RegisterController: UIViewController, WebServiceDelegate {
    
    var userLoggedIn: User?
    
    let webservice = WebService()
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var password2: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var state: UITextField!
    @IBOutlet weak var zipCode: UITextField!
    @IBOutlet weak var errorMsg: UILabel!
    @IBOutlet weak var handyMan: UISwitch!
    
    override func viewDidLoad() {
        handyMan.isOn = false
        errorMsg.isHidden = true
        webservice.delegate = self
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "registrationToHome" {
            let tabVC = segue.destination as! UITabBarController
            let homeVC = tabVC.viewControllers?.first as! HomeController
            homeVC.userLoggedIn = self.userLoggedIn
            homeVC.loadViewIfNeeded()
        }
    }
    
    //function for the on/off handyman or not button
    @IBAction func isHandyMan(_ sender: Any) {
        if handyMan.isOn {
            handyMan.isOn = false
        } else {
            handyMan.setOn(true, animated: true)
        }
    }
    
    @IBAction func register(_ sender: Any) {
        if ((firstName.text == "") || (lastName.text == "") || (email.text == "") || (password.text == "") || (password2.text == "") || (city.text == "") || (state.text == "") || (zipCode.text == "") || password.text != password2.text) {
            
            errorMsg.isHidden = false;
            
            if (password2.text != password.text) {
                errorMsg.text = "Passwords do not match!"
            }
            
            else {
                errorMsg.text = "Please enter values in all of the fields!"
            }
        }
        
        else {
            
            if handyMan.isOn {
                errorMsg.isHidden = true
                newUser = User(firstName: firstName.text!, lastName: lastName.text!, email: email.text!, state: state.text!, city: city.text!, password: password.text!, password2: password2.text!, zipCode: zipCode.text!, isHMan: "YES", skills: "", experience: "", latitude: "\(String(describing: currentLoc!.latitude))", longitude: "\(String(describing: currentLoc!.longitude))")
                performSegue(withIdentifier: "registrationContinued", sender: self)
            }
            
            else {
                newUser = User(firstName: firstName.text!, lastName: lastName.text!, email: email.text!, state: state.text!, city: city.text!, password: password.text!, password2: password2.text!, zipCode: zipCode.text!, isHMan: "NO", skills: "", experience: "", latitude: "\(String(describing: currentLoc!.latitude))", longitude: "\(String(describing: currentLoc!.longitude))")
                errorMsg.isHidden = true
                webservice.register(finished: { isFinished in
                    if isFinished {
                        DispatchQueue.main.async {
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            let context = appDelegate.persistentContainer.viewContext
                            let entity = NSEntityDescription.entity(forEntityName: "Users", in: context)
                            let nUser = NSManagedObject(entity: entity!, insertInto: context)
                            nUser.setValue(newUser.email, forKey: "username")
                            nUser.setValue(newUser.password, forKey: "password")
                            do {
                                try context.save()
                                self.performSegue(withIdentifier: "registrationToHome", sender: self)
                            } catch {
                                print("Failed saving")
                            }
                        }
                    } else {
                        print("error registering")
                    }
                })
                //userLoggedIn = newUser
                
            }
            
        }
    }
    
    
    @IBAction func backToLogin(_ sender: UIBarButtonItem) {
        newUser = User()
        dismiss(animated: true, completion: nil)
    }
    
    func getUserData(user: User) {
        self.userLoggedIn = user
        print(self.userLoggedIn)
        print("jdahgsdhjsgdhjgasjhkdgk")
    }
    
}
