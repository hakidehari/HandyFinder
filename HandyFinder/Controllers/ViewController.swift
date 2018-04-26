//
//  ViewController.swift
//  HandyFinder
//
//  Created by Haki Dehari on 2/2/18.
//  Copyright © 2018 EpochApps. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

var count = 0
var loginInfo = [String: String]()
var currentLoc: CLLocationCoordinate2D?

class ViewController: UIViewController, WebServiceDelegate, CLLocationManagerDelegate {
    
    //location manager
    var locationManager: CLLocationManager!
    
    //webservice object used for protocol and login function
    var webService = WebService()
    
    var userLoggedIn: User?
    
    @IBOutlet weak var userField: UITextField!
    @IBOutlet weak var passField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webService.delegate = self
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLoc = manager.location?.coordinate
        manager.stopUpdatingLocation()
        if count == 0 {
            count += 1
            checkCoreData()
        }
        print(currentLoc)
        
    }
    
    func checkCoreData() {
        DispatchQueue.main.async {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
            request.returnsObjectsAsFaults = false
            do {
                let result = try context.fetch(request)
                if result.count != 0 {
                    let user = result[0] as! NSManagedObject
                    loginInfo["email"] = user.value(forKey: "username") as! String
                    loginInfo["password"] = user.value(forKey: "password") as! String
                    loginInfo["latitude"] = "\(String(describing: currentLoc!.latitude))"
                    loginInfo["longitude"] = "\(String(describing: currentLoc!.longitude))"
                    print(loginInfo["latitude"])
                    self.webService.login(finished: { Bool in
                        if Bool {
                            print("login success1")
                            self.performSegue(withIdentifier: "isLoggedIn", sender: self)
                        } else {
                            print("login failed")
                        }
                    })//end completion handler
                }//end if
                
            }//end do
            catch {
                print("Failed")
            }//end catch
        }
    }
    

    @IBAction func register(_ sender: Any) {
        performSegue(withIdentifier: "register", sender: self)
    }
    
    
    //logs the user in using email and password fields
    @IBAction func login(_ sender: Any) {
        loginInfo["email"] = userField.text
        loginInfo["password"] = passField.text
        loginInfo["latitude"] = "\(String(describing: currentLoc!.latitude))"
        loginInfo["longitude"] = "\(String(describing: currentLoc!.longitude))"
        print(loginInfo["latitude"])
        webService.login( finished: { Bool in
            //if login success continue on to save coredata and perform segue
            if Bool {
                print(self.userLoggedIn?.firstName)
                print("login success")
                
                //handles core data insertion on main thread, then performs segue to Home
                var appDelegate: AppDelegate!
                var context: NSManagedObjectContext!
                DispatchQueue.main.async {
                    appDelegate = UIApplication.shared.delegate as! AppDelegate
                    context = appDelegate.persistentContainer.viewContext
                    let entity = NSEntityDescription.entity(forEntityName: "Users", in: context)
                    let nUser = NSManagedObject(entity: entity!, insertInto: context)
                    nUser.setValue(loginInfo["email"], forKey: "username")
                    nUser.setValue(loginInfo["password"], forKey: "password")
                    do {
                        try context.save()
                        self.performSegue(withIdentifier: "isLoggedIn", sender: self)
                    } catch {
                        print("Failed saving")
                    }
                }//end main thread dispatch queue
            }//end if
            else {
                print("error logging in")
            }//end else
        })//end onCompletion
    }//end login()
    
    
    //gets VC and user data ready to send to the Home VC before performing the segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "isLoggedIn" {
            let tabVC = segue.destination as! UITabBarController
            let homeVC = tabVC.viewControllers?.first as! HomeController
            homeVC.userLoggedIn = self.userLoggedIn
            homeVC.loadViewIfNeeded()
            print("prepareforsgue")
        }
    }
    
    
    //loads in user data retrieved from DB from webservice using webservice protocol
    func getUserData(user: User) {
        self.userLoggedIn = user
        print("success delegate")
        print(user)
    }
    
    
}

