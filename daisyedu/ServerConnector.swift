//
//  ServerConnector.swift
//  daisyedu
//
//  Created by Максим Чистов on 05.03.15.
//  Copyright (c) 2015 Максим Чистов. All rights reserved.
//
import Foundation;


//вся работа с серверным апи идет через него
public class Server {
    let resources = "http://daisyedu.com/rest/resource";
    let resource = "http://daisyedu.com/rest/resource&id=";
    var data = DocumentsList();
    var useCache=false;
    public init() {
        if !useCache {
            let request = self.resources
            let encoded = request.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
            var url: NSURL = NSURL( string: encoded!)!
            var session = NSURLSession.sharedSession()
            var task = session.dataTaskWithURL(url, completionHandler: {data, response, error -> Void in
                println("Task completed")
                if((error) != nil) {
                    println(error.localizedDescription)
                }
                dispatch_async(dispatch_get_main_queue(), {
                self.data = DocumentsList(RawJSON: NSString(data:data, encoding:NSUTF8StringEncoding)!)
                })
            })
            task.resume()
        } else { exit(42);}
    }
}

//в фоновом потоке работает, изредка дергает основной по событиям
public class Worker {
    private var s:Server;
    private var working = false;
    public init(S:Server) {
        s=S;
        DoWork();
    }
    public func DoWork() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),{
            while(true) {
                if(self.working) {
                    //TODO:фоновые задачи - сюда
                }
            }
            } );
    }
    public func Start() {
        working = true;
    }
    public func Pause() {
        working = false;
    }
}
