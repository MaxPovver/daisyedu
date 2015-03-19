//
//  MenuViewController.swift
//  daisyedu
//
//  Created by Максим Чистов on 17.03.15.
//  Copyright (c) 2015 Максим Чистов. All rights reserved.
//


import UIKit
//обработчик менюшки 
class MenuViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("MenuToMain", sender: indexPath)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let p = sender as NSIndexPath
        let d =  (segue.destinationViewController as UINavigationController).childViewControllers[0] as MainViewController;
        d.SetFilter(p.item)
    }
}