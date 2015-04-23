//
//  Books.swift
//  daisyedu
//
//  Created by Максим Чистов on 23.04.15.
//  Copyright (c) 2015 Максим Чистов. All rights reserved.
//

import UIKit


public class BooksViewController: UICollectionViewController {
    
    private var books:[TreeNode] = []
    override public func viewDidLoad() {
        super.viewDidLoad()
        if s==nil || s!.Bad {
            s = Server(loadedCallback: loaded)
        } else {
            dispatch_async(
                
                dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
                    while(!s!.loaded) {}
                    self.loaded()
            })
        }
    }
    func loaded() {
        books = s!.getBooks()
        collectionView?.reloadData()
    }
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    public override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell =  collectionView.dequeueReusableCellWithReuseIdentifier("BookCell", forIndexPath: indexPath) as! CollCellView
        cell.set(books[indexPath.item])
        return cell
    }
    public override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("ShowDetail", sender: indexPath)
    }
    override public func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowDetail" {
            let p = sender as! NSIndexPath
            var item:TreeNode? = books[p.item];
            if item != nil {
                let d =  segue.destinationViewController as! DetailViewController
                let tmp = s!.load(item!.value, real: d.recieve)
                d.setDoc(tmp)
                d.setNode(item!)
            }
        }
    }
    public override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return books.count
    }
}
