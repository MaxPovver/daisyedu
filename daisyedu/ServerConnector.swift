//
//  ServerConnector.swift
//  daisyedu
//
//  Created by Максим Чистов on 05.03.15.
//  Copyright (c) 2015 Максим Чистов. All rights reserved.
//
import Foundation;

var s:Server=Server();

//вся работа с серверным апи идет через него
public class Server {
    let resources = "http://daisyedu.com/rest/resource";
    let resource = "http://daisyedu.com/rest/resource&id=";
    var data = DocumentsList();
    var useCache = true;
    public var Bad = false;
    var loadedCallback:()->Void;
    public init()
    {
        loadedCallback = {}
        Bad = true
    }
    public init(loadedCallback lbc:()->Void) {
        let request = self.resources
        loadedCallback = lbc
        if useCache {
            if let tmp = NSUserDefaults.standardUserDefaults().objectForKey("docs_list") as? [NSObject:AnyObject] {
                self.data = DocumentsList(json: tmp)
                lbc()
            }
        s = self
        }
        let encoded = request.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        var url: NSURL = NSURL( string: encoded!)!
        var session = NSURLSession.sharedSession()
        var task = session.dataTaskWithURL(url, completionHandler: {data, response, error -> Void in
            println("Docs list loaded")
            if((error) != nil) {
                println(error.localizedDescription)
            } else  {
            dispatch_async(dispatch_get_main_queue(), {
                self.data = DocumentsList(RawJSON: NSString(data:data, encoding:NSUTF8StringEncoding)!)
                self.loadedCallback()
                })
                NSUserDefaults.standardUserDefaults().setObject(self.data.back(), forKey: "docs_list")
            }
            })
            task.resume()
    }
    public func getDocs()->DocumentsList {
        return data
    }
    public func getTree()->DocTree {
        return getDocs().getTree()
    }
    //получает из сети полную инфу по конкретному доку
    //сразу возвращает из кеша(если есть), либо заглушку
    public func load(sd:SmallDocument, real:(Document)->Void)->Document {
        var res:Document?;
       let d = NSUserDefaults.standardUserDefaults()
        var tmp = d.objectForKey("document\(sd.getID())") as? [NSObject:AnyObject]
        if tmp == nil {
            res = Document.stub()
        } else {
            res = Document(WithJSON: tmp!)
        }
        let request = self.resource + "\(sd.getID())"
        let encoded = request.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        var url: NSURL = NSURL( string: encoded!)!
        var session = NSURLSession.sharedSession()
        var task = session.dataTaskWithURL(url, completionHandler: {data, response, error -> Void in
            println("Doc loaded: "+NSString(data:data, encoding:NSUTF8StringEncoding)!)
            if((error) != nil) {
                println(error.localizedDescription)
            } else {
            dispatch_async(dispatch_get_main_queue(), {
                var x = Document(_json: NSString(data:data, encoding:NSUTF8StringEncoding)!,sd: sd)
                /* var err: NSError?
                var jsonStr = NSJSONSerialization.dataWithJSONObject(x, options: NSJSONWritingOptions.PrettyPrinted, error: &err)*/
                d.setObject(x.back(), forKey: "document\(sd.getID())")
                real(x);
            })
            }
        })
        task.resume()
        
        return res!;
    }
    public func CoachToStr(id:String)->String {
        let _id = id.toInt()! 
        return getDocs().asCollection().filter({$0.getID()==_id})[0].getTitle()
    }
    public func FormatToStr(id:String)->String {
        switch (id) {
        case "1": return "Онлайн";
        case "2": return "Оффлайн";
        default: return "";
        }
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
