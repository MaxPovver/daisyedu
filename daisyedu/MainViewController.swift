//
//  ViewController.swift
//  daisyedu
//
//  Created by Максим Чистов on 05.03.15.
//  Copyright (c) 2015 Максим Чистов. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController {

    @IBOutlet weak var menuBtn: UIBarButtonItem!
    required init(coder aDecoder: NSCoder) {
        server = Server()
        super.init(coder: aDecoder)
        
    }
    var server:Server;
    var docsFilter = -1;
    func SetFilter(newF:Int) {
        docsFilter = newF
        filterCourses()
    }
    func filterCourses() {
        switch(docsFilter) {
        case 1://Всё(по умолчанию)
            break;
        case 2://По категориям
            break;
        case 3://События
            break;
        case 4://Книги
            break;
        case 5://Новости
            break;
        default:// по умолчанию всё
            SetFilter(1)
        }
    }
    //вызывается после получения от сервера очередной порции данных
    func dataLoaded() {
         tableView.reloadData()
    }
    override func viewDidLoad() {
        server = Server(loadedCallback: dataLoaded)
        super.viewDidLoad()
       // menuBtn.target = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        server.getDocs().getTree().DropCaches()
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DocCell") as! UITableViewCell
        let first = server.getTree().getLayer(1)
        if first[indexPath.section].value.getID() != 2 {
            let layer = server.getTree().getLayer(2, filterID: first[indexPath.section].value.getID());
            cell.textLabel?.text = layer[indexPath.row].value.getTitle()
        } else {
            let layer = server.getTree().getAll3Plus()
            cell.textLabel?.text = layer[indexPath.row].value.getTitle()
        }
        
        return cell
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("ShowDetail", sender: indexPath)
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let tmp = server.getTree().getLayer(1)[section];
        if tmp.value.getID() != 2 {
            return server.getTree().getLayer(2, filterID: tmp.value.getID()).count
        }
        return server.getTree().getAll3Plus().count
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return server.getTree().getLayer(1).count
    }
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var x = server.getTree().getLayer(1)[section];//.value.getTitle()
        if x.value.getID() != 2 { return x.value.getTitle() }
        else { return "Курсы и тренинги" }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowDetail" {
        let p = sender as! NSIndexPath
        var item:TreeNode?
        if p.section != -1 {
            let x = server.getTree().getLayer(1)[p.section];
            if x.value.getID() != 2 {
                item = server.getTree().getLayer(2, filterID: x.value.getID())[p.row]
            } else {
                item = server.getTree().getAll3Plus()[p.row]
                }
        } else {
            item = server.getTree().getForID(p.item)
        }
        if item != nil {
            let d =  segue.destinationViewController as! DetailViewController
            let tmp = server.load(item!.value, real: d.recieve)
            d.setDoc(tmp)
            d.setNode(item!)
        }
        }
    }

}

