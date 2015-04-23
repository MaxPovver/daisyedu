//
//  DetailViewController.swift
//  daisyedu
//
//  Created by Максим Чистов on 06.03.15.
//  Copyright (c) 2015 Максим Чистов. All rights reserved.
//
import UIKit

public class DetailViewController: UIViewController,UIWebViewDelegate {
    
    @IBOutlet weak var Content: UIWebView!
    
    required public init(coder aDecoder: NSCoder) {
        doc = Document.stub()
        
        super.init(coder: aDecoder)
    }
    var doc:Document;
    var node:TreeNode?
    override public func viewDidLoad() {
        super.viewDidLoad()
        Content.delegate = self
        recieve(doc)
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setDoc( d:Document) { doc = d}
    func setNode(t:TreeNode) { node = t}
    func recieve(document:Document) {
        doc = document
        navigationItem.title = doc.getTitle()
        //navigationItem.prompt = node?.pathTo()
        Content.loadHTMLString(doc.getContent(), baseURL: NSURL(string: "http://daisyedu.com/"))
    }
    
    public func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let url = request.URL!.path!.lastPathComponent
        println("path = \(url)")
        if url == "/"{
            return true
        }
        if url.toInt() != nil {
            GoTo(url.toInt()!)
        }
        return false
    }
    //отправляет на страничку тернера в приложении
    public func GoTo(id:Int) {
        let p = navigationController?.childViewControllers[0] as! MainViewController
        p.performSegueWithIdentifier("ShowDetail", sender: NSIndexPath(forItem: id, inSection: -1))
    }
}