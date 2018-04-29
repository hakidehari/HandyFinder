//
//  SearchController.swift
//  HandyFinder
//
//  Created by Haki Dehari on 4/7/18.
//  Copyright © 2018 EpochApps. All rights reserved.
//

import Foundation
import UIKit

class SearchController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var handymen: Array<NSDictionary> = []
    
    var userLoggedIn: User?
    
    @IBOutlet weak var handymanTable: UITableView!
    
    let webService = WebService()
    
    override func viewDidLoad() {
        handymanTable.delegate = self
        handymanTable.dataSource = self
        handymanTable.reloadData()
    }
    
    @IBAction func backPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return handymen.count
    }
    
    //will be implemented once search functionality is complete
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellSearch")
        cell?.textLabel?.text = "hello"
        return cell!
    }
    
}
