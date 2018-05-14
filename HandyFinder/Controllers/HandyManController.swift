//
//  HandyManController.swift
//  HandyFinder
//
//  Created by Haki Dehari on 5/1/18.
//  Copyright © 2018 EpochApps. All rights reserved.
//

import UIKit

class HandyManController: UIViewController {
    
    var userLoggedIn: User?
    
    var handyMan: NSDictionary?
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var skillsTextView: UITextView!
    
    @IBOutlet weak var experienceTextView: UITextView!
    @IBAction func contactHandyMan(_ sender: Any) {
        return
    }
    
    override func viewDidLoad() {
        skillsTextView.text = handyMan!["skills"] as! String
        experienceTextView.text = handyMan!["experience"] as! String
        let firstName = handyMan!["firstName"] as! String
        let lastName = handyMan!["lastName"] as! String
        navBar.topItem?.title = firstName + " " + lastName
    }
    @IBAction func backToHome(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
