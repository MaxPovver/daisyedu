//
//  CollCellView.swift
//  daisyedu
//
//  Created by Максим Чистов on 23.04.15.
//  Copyright (c) 2015 Максим Чистов. All rights reserved.
//
import UIKit

public class CollCellView: UICollectionViewCell {

    @IBOutlet weak var Title: UILabel!
    @IBOutlet weak var Picture: UIImageView!
    public func set(node:TreeNode) {
        dispatch_async(
            
            dispatch_get_main_queue(),{
        self.Title.text = node.value.getTitle()
        let cache_path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).last as! String
        let path = cache_path + "/\(node.value.getID()).jpg"
       if NSFileManager.defaultManager().fileExistsAtPath(path)
       {
            self.Picture.image = UIImage(contentsOfFile: path)
       } else {
        var request =  node.value.getImage()!
        if !(request.hasPrefix("http") ) {
            request = "http://daisyedu.com/" + request
        }
        var data = NSData(contentsOfURL: NSURL(string:request.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)!)
         self.Picture.image = UIImage(data: data!)
        dispatch_async(
            
                dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {autoreleasepool {
                    if data!.writeToFile(path, atomically: true) {
                        println(path+" saved")
                    } else {
                        println(path+" failed")
                    }
                    data = nil
                }
        })
        }
        })
        
    }
}