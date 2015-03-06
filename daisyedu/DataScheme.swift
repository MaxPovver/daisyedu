//
//  DataScheme.swift
//  daisyedu
//
//  Created by Максим Чистов on 05.03.15.
//  Copyright (c) 2015 Максим Чистов. All rights reserved.
//

import Foundation;

/*  json example
{"message":"","object":{"id":1,"type":"document","contentType":"text\/html","pagetitle":"\u0413\u043b\u0430\u0432\u043d\u0430\u044f","longtitle":"","description":"","alias":"home","link_attributes":"","published":true,"pub_date":0,"unpub_date":0,"parent":0,"isfolder":true,"introtext":"","content":"","richtext":true,"template":1,"menuindex":0,"searchable":true,"cacheable":true,"createdby":1,"createdon":"2015-01-21 14:00:46","editedby":1,"editedon":"2015-01-21 20:58:24","deleted":false,"deletedon":0,"deletedby":0,"publishedon":0,"publishedby":0,"menutitle":"","donthit":false,"privateweb":false,"privatemgr":false,"content_dispo":0,"hidemenu":false,"class_key":"modDocument","context_key":"web","content_type":1,"uri":"home","uri_override":0,"hide_children_in_tree":0,"show_in_tree":1,"properties":null},"success":true}
*/
//для хранения подробной инфы о документе
public class Document {
    public class func stub()->Document {return Document(ID: 0,Title: "Загрузка...",Content: "Загрузка...Подождите, пожалуйста")}
    private var _id = 0;
    private var _parent = 0;
    private var _title = "";
    private var _content = "";
    private var _description = "";
    private var _published = "";
    private var _introtext = "";
    private var _createdon = "";
    private var _editedon = "";
    public init(_json:String) {
        var err: NSError?
        var json = NSJSONSerialization.JSONObjectWithData(_json.dataUsingEncoding(NSUTF8StringEncoding)!, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
        if !initwj(json) { exit(42); }
    }
    private func initwj(json:[NSObject:AnyObject])->Bool {
        if let __id = json["id"] as? Int{
            if let __title = json["pagetitle"] as? String{
                if let __description = json["description"] as? String{
                    if let __published = json["published"] as? String{
                        if let __introtext = json["introtext"] as? String{
                            if let __createdon = json["createdon"] as? String{
                                if let __editedon = json["publishedon"] as? String{
                                    if let __parent = json["parent"] as? Int {
                                        if let __content = json["content"] as? String {
                                            _id = __id
                                            _title = __title
                                            _description = __description
                                            _published = __published
                                            _introtext = __introtext
                                            _createdon = __createdon
                                            _editedon = __editedon
                                            _content = __content
                                            return true;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        return false;
    }
    public init(WithJSON json:[NSObject:AnyObject]) {
        if !initwj(json) { exit(42); }
    }
    public init(ID __id:Int,Parent __parent:Int,Title __title:String, Content __content:String,Description __desc:String,
        PublishedOn __publ:String, Introtext __intro:String, CreatedOn __created:String, EditedOn __edited:String) {
        _id = __id;
        _content = __content
        _parent = __parent;
        _title = __title;
        _description = __desc;
        _published = __publ;
        _introtext = __intro;
        _createdon = __created;
        _editedon = __edited;
    }
    public init(ID id:Int,Title title:String,Content content:String) {
        _id = id
        _title = title
        _content = content
    }
    public func getID()->Int {
    return _id;
    }
    public func getParent()->Int {
        return _parent;
    }
    public func getTitle()->String {
        return _title;
    }
    public func getIntrotext()->String {
        return _introtext;
    }
    public func isPublished()->Bool {
        return _published == "true";
    }
    public func getCreationDate()->String {
        return _createdon;
    }
    public func getEditDate()->String {
        return _editedon;
    }
}
//минифицированная версия документа для списка курсов(только заголовок и id)
public class SmallDocument {
    private var _id = 0;
    private var _title = "";
    private func initwj(json:[NSObject:AnyObject]) {
        if json["id"]==nil || json["pagetitle"]==nil {
            exit(42)
        }
        _id = json["id"] as Int
        _title = json["pagetitle"] as String
    }
    public init(_json:String) {
        var err: NSError?
        var json = NSJSONSerialization.JSONObjectWithData(_json.dataUsingEncoding(NSUTF8StringEncoding)!, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
        initwj(json)
    }
    public init(WithJSON json:[NSObject:AnyObject]) {
        initwj(json)
    }
    public func getID()->Int {
        return _id;
    }
    public func getTitle()->String {
        return _title;
    }
}

//для хранения списка статей(без текста?)
public class DocumentsList {
    private var docs:[SmallDocument];
    public init(RawJSON rawJson:String) {
        if(rawJson.isEmpty) {
            //TODO: обрабатывать тут пустую строку
            docs = [SmallDocument]()
            println("Empty server response")
            return;
        } else {
        var err: NSError?
        var json = NSJSONSerialization.JSONObjectWithData(rawJson.dataUsingEncoding(NSUTF8StringEncoding)!, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
        println(rawJson)
        func converter()(el:AnyObject)->SmallDocument {
                return SmallDocument(WithJSON: el as NSDictionary)
        }
        if let count = json["total"] as? NSInteger {
            
            if let results = json["results"] as? [NSDictionary]{
                docs = results.map(converter())
                return;
            }
        }
        exit(42);
        }
    }
    public init(){ docs = [SmallDocument]()}
    public func count()->Int {
        return docs.count
    }
    public func at(_i:Int)->SmallDocument {
        let x  = docs[_i]
        return x
    }
    public func asCollection()->[SmallDocument] {
        return docs
    }
}











































