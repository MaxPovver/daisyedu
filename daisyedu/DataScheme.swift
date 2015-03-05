//
//  DataScheme.swift
//  daisyedu
//
//  Created by Максим Чистов on 05.03.15.
//  Copyright (c) 2015 Максим Чистов. All rights reserved.
//

import Foundation;

/*
{"message":"","object":{"id":1,"type":"document","contentType":"text\/html","pagetitle":"\u0413\u043b\u0430\u0432\u043d\u0430\u044f","longtitle":"","description":"","alias":"home","link_attributes":"","published":true,"pub_date":0,"unpub_date":0,"parent":0,"isfolder":true,"introtext":"","content":"","richtext":true,"template":1,"menuindex":0,"searchable":true,"cacheable":true,"createdby":1,"createdon":"2015-01-21 14:00:46","editedby":1,"editedon":"2015-01-21 20:58:24","deleted":false,"deletedon":0,"deletedby":0,"publishedon":0,"publishedby":0,"menutitle":"","donthit":false,"privateweb":false,"privatemgr":false,"content_dispo":0,"hidemenu":false,"class_key":"modDocument","context_key":"web","content_type":1,"uri":"home","uri_override":0,"hide_children_in_tree":0,"show_in_tree":1,"properties":null},"success":true}
*/
//для хранения подробной инфы о документе
public class Document {
    private var _id:String;
    private var _title:String;
    private var _description:String;
    private var _published:String;
    private var _introtext:String;
    private var _createdon:String;
    private var _editedon:String;
    public init(_json:String) {
        var err: NSError?
        var json = NSJSONSerialization.JSONObjectWithData(_json.dataUsingEncoding(NSUTF8StringEncoding)!, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
        if !initwj(json) { exit(42); }
    }
    private func initwj(json:[NSObject:AnyObject])->Bool {
        if let _id = json["id"] as? String{
            if let _title = json["pagetitle"] as? String{
                if let _description = json["description"] as? String{
                    if let _published = json["published"] as? String{
                        if let _introtext = json["introtext"] as? String{
                            if let _createdon = json["createdon"] as? String{
                                if let _editedon = json["publishedon"] as? String{
                                    return true;
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
    public init(ID __id:String,Title __title:String, Description __desc:String,
        PublishedOn __publ:String, Introtext __intro:String, CreatedOn __created:String, EditedOn __edited:String) {
        _id = __id;
        _title = __title;
        _description = __desc;
        _published = __publ;
        _introtext = __intro;
        _createdon = __created;
        _editedon = __edited;
    }
}

//для хранения списка статей(без текста?)
public class DocumentsList {
    private var docs:[Documents];
}