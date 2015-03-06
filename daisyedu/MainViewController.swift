//
//  ViewController.swift
//  daisyedu
//
//  Created by Максим Чистов on 05.03.15.
//  Copyright (c) 2015 Максим Чистов. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController {

    required init(coder aDecoder: NSCoder) {
        server = Server()
        super.init(coder: aDecoder)
        
    }
    var server:Server;
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

