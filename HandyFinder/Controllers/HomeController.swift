//
//  HomeController.swift
//  HandyFinder
//
//  Created by Haki Dehari on 3/16/18.
//  Copyright © 2018 EpochApps. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class HomeController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var handymen: Array<NSDictionary> = []
    
    var handyman: NSDictionary?
    
    let webService = WebService()
    
    var userLoggedIn: User?
    
    @IBOutlet weak var handyManTable: UITableView!
    
    override func viewDidLoad() {
        handyManTable.delegate = self
        handyManTable.dataSource = self
        webService.retrieveHandyMen() { (response) in
            self.handymen = response as! Array<NSDictionary>
            DispatchQueue.main.async {
                self.handyManTable.reloadData()
            }
        }
    }
    
    //overridden function that does certain things before performing the segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "homeToSearch" {
            let searchVC = segue.destination as! SearchController
            searchVC.userLoggedIn = self.userLoggedIn
            searchVC.loadViewIfNeeded()
        }
        
        if segue.identifier == "homeToHandyMan" {
            let handyManVC = segue.destination as! HandyManController
            handyManVC.userLoggedIn = self.userLoggedIn
            handyManVC.handyMan = self.handyman
            handyManVC.loadViewIfNeeded()
        }
    }//end prepare for segue method
    
    //delegate function that dictates the number of rows in the table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if handymen.count == 0 {
            return 1
        } else {
            return handymen.count
        }
    }
    
    @IBAction func goToPost(_ sender: Any) {
        performSegue(withIdentifier: "homeToSearch", sender: self)
    }
    
    //delegate function that populates the table with handymen in your area
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if handymen.count == 0 {
            cell?.textLabel?.text = "Sorry, there are no handymen in your area"
        }
        else {
            cell?.textLabel?.text = handymen[indexPath.row]["firstName"] as! String
        }
        return cell!
    }
    
    //delegate function that performs an action when a row in the table is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.handyman = handymen[indexPath.row]
        performSegue(withIdentifier: "homeToHandyMan", sender: self)
    }
    
    
    //function that logs out and deletes coreData
    @IBAction func logout(_ sender: Any) {
        print(userLoggedIn)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        request.returnsObjectsAsFaults = false
        do {
            if let result = try? context.fetch(request) {
                for object in result {
                    context.delete(object as! NSManagedObject)
                    try context.save()
                }
                userLoggedIn = User()
                performSegue(withIdentifier: "backToLogin", sender: self)
            }
            
        } catch {
            
            print("Failed to fetch or save context")
        }
    }
    
    
}

