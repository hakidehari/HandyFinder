//
//  RegistrationContController.swift
//  HandyFinder
//
//  Created by Haki Dehari on 2/27/18.
//  Copyright © 2018 EpochApps. All rights reserved.
//

import Foundation
import UIKit
import CoreData



class RegistrationContController: UIViewController, WebServiceDelegate {
    
    let webservice = WebService()
    
    var userLoggedIn: User?
    
    @IBOutlet weak var skills: UITextField!
    @IBOutlet weak var experience: UITextField!
    @IBOutlet weak var errorMsg: UILabel!
    
    override func viewDidLoad() {
        errorMsg.isHidden = true
        webservice.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "registrationContToHome" {
            let tabVC = segue.destination as! UITabBarController
            let homeVC = tabVC.viewControllers?.first as! HomeController
            homeVC.userLoggedIn = self.userLoggedIn
            homeVC.loadViewIfNeeded()
        }
    }
    
    
    @IBAction func registrationCont(_ sender: Any) {
        if skills.text == "" || experience.text == "" {
            errorMsg.isHidden = false
        }
        else {
            errorMsg.isHidden = true
            newUser.skills = skills.text!
            newUser.experience = experience.text!
            webservice.register(finished: { isFinished in
                if isFinished {
                    DispatchQueue.main.async {
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        let context = appDelegate.persistentContainer.viewContext
                        let entity = NSEntityDescription.entity(forEntityName: "Users", in: context)
                        let nUser = NSManagedObject(entity: entity!, insertInto: context)
                        nUser.setValue(self.userLoggedIn?.email, forKey: "username")
                        nUser.setValue(self.userLoggedIn?.password, forKey: "password")
                        do {
                            try context.save()
                            self.performSegue(withIdentifier: "registrationContToHome", sender: self)
                        } catch {
                            print("Failed saving")
                        }
                    }
                } else {
                    print("failed to register")
                }
            })
            //userLoggedIn = newUser
            
        }
        
    }
    
    @IBAction func backToRegistration(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    func getUserData(user: User) {
        self.userLoggedIn = user
    }
    
    
}
