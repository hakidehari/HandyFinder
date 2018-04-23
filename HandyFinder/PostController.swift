//
//  PostController.swift
//  HandyFinder
//
//  Created by Haki Dehari on 4/7/18.
//  Copyright © 2018 EpochApps. All rights reserved.
//

import Foundation
import UIKit

class PostController: UIViewController {
    
    var userLoggedIn: User?
    
    let webService = WebService()
    
    @IBAction func backPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
