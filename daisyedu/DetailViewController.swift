//
//  DetailViewController.swift
//  daisyedu
//
//  Created by Максим Чистов on 06.03.15.
//  Copyright (c) 2015 Максим Чистов. All rights reserved.
//
import UIKit

 class DetailViewController: UIViewController {
    
    @IBOutlet weak var Content: UIWebView!
    required init(coder aDecoder: NSCoder) {
        doc = Document.stub()
        super.init(coder: aDecoder)
    }
    var doc:Document;
    var node:TreeNode?
    override func viewDidLoad() {
        super.viewDidLoad()
        recieve(doc)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setDoc( d:Document) { doc = d}
    func setNode(t:TreeNode) { node = t}
    func recieve(document:Document) {
        doc = document
       // Title.text = doc.getTitle()
        navigationItem.title = doc.getTitle()
        navigationItem.prompt = node?.pathTo()
        Content.loadHTMLString(doc.getContent(), baseURL: NSURL(string: "http://daisyedu.com/"))
    }
}