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
    public var Bad = false;
    var loadedCallback:()->Void;
    public init()
    {
        loadedCallback = {}
        Bad = true
    }
    public init(loadedCallback lbc:()->Void) {
        if !useCache {
            let request = self.resources
            loadedCallback = lbc
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
                    lbc();
                })
            })
            task.resume()
        } else { exit(42);}
    }
    public func getDocs()->DocumentsList {
        return data
    }
    //получает из сети полную инфу по конкретному доку
    //сразу возвращает из кеша(если есть), либо заглушку
    public func load(sd:SmallDocument, real:(Document)->Void)->Document {
        var res:Document?;
       let d = NSUserDefaults.standardUserDefaults()
        res = d.objectForKey("document\(sd.getID())") as Document?
        if res == nil {
            res = Document.stub()
        }
        let request = self.resource + "\(sd.getID())"
        let encoded = request.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        var url: NSURL = NSURL( string: encoded!)!
        var session = NSURLSession.sharedSession()
        var task = session.dataTaskWithURL(url, completionHandler: {data, response, error -> Void in
            println("Task completed")
            if((error) != nil) {
                println(error.localizedDescription)
            }
            dispatch_async(dispatch_get_main_queue(), {
                var x = Document(_json: NSString(data:data, encoding:NSUTF8StringEncoding)!)
                d.setObject(x, forKey: "document\(sd.getID())")
                real(x);
            })
        })
        task.resume()
        
        return res!;
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
