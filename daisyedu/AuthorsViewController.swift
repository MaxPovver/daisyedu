//
//  AuthorsVC.swift
//  daisyedu
//
//  Created by Максим Чистов on 23.04.15.
//  Copyright (c) 2015 Максим Чистов. All rights reserved.
//

import UIKit


public class AuthorsViewController: UICollectionViewController {
    
    private var authors:[TreeNode] = []
    override public func viewDidLoad() {
        super.viewDidLoad()
        if s==nil || s!.Bad {
            s = Server(loadedCallback: loaded)
        }
    }
    func loaded() {
        sleep(1)
        authors = s!.getCoaches()
        collectionView?.reloadData()
    }
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    public override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell =  collectionView.dequeueReusableCellWithReuseIdentifier("AuthorCell", forIndexPath: indexPath) as! CollCellView
        cell.set(authors[indexPath.item])
        return cell
    }
    public override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("ShowDetail", sender: indexPath)
    }
    override public func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowDetail" {
            let p = sender as! NSIndexPath
            var item:TreeNode? = authors[p.item];
            if item != nil {
                let d =  segue.destinationViewController as! DetailViewController
                let tmp = s!.load(item!.value, real: d.recieve)
                d.setDoc(tmp)
                d.setNode(item!)
            }
        }
    }
    public override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return authors.count
    }
}
