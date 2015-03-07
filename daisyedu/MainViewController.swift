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
        server = Server(dataLoaded)
    }
    var server:Server;
    //вызывается после получения сервером очередной порции данных
    func dataLoaded() {
        tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DocCell") as UITableViewCell
        cell.textLabel.text = "\(server.getDocs().at(indexPath.item).getTitle())  \(indexPath.item)"
        return cell
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("ShowDetail", sender: indexPath.item)
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return server.getDocs().count()
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let item = server.getDocs().at(sender as Int)
    let d =  segue.destinationViewController as DetailViewController
        let tmp = server.load(item, real: d.recieve)
        d.setDoc(tmp)
    }

}

