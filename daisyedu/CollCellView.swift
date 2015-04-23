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
    @IBOutlet weak var Picture: UIWebView!
    public func set(node:TreeNode) {
        Title.text = node.value.getTitle()
        let url = "<img src=\"\(node.value.getImage()!)\" width=\"100%\">"
        Picture.loadHTMLString(url, baseURL: NSURL(string: "http://daisyedu.com/"))
    }
}