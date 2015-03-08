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
    public class func stub()->Document {return Document(ID: 0,Title: "Загрузка...",Content: "Загрузка...")}
    private var _id = 0;
    private var _parent = 0;
    private var _title = "";
    private var _content = "";
    private var _description = "";
    private var _published = false;
    private var _introtext = "";
    private var _createdon = "";
    private var _editedon = "";
    public init(_json:String) {
        var err: NSError?
        var json = NSJSONSerialization.JSONObjectWithData(_json.dataUsingEncoding(NSUTF8StringEncoding)!, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
        if !initwj(json) { exit(42); }
    }
    private func initwj(_json:[NSObject:AnyObject])->Bool {
        let json = _json["object"] as NSDictionary
        if let __id = json["id"] as? Int{
            if let __title = json["pagetitle"] as? String{
                if let __description = json["description"] as? String{
                    if let __published = json["published"] as? Bool{
                        if let __introtext = json["introtext"] as? String{
                            if let __createdon = json["createdon"] as? String{
                                if json["editedon"] != nil {//или 0 или строка (!!!)
                                    if let __parent = json["parent"] as? Int {
                                        if let __content = json["content"] as? String {
                                            _id = __id
                                            _parent = __parent
                                            _title = __title
                                            _description = __description
                                            _published = __published
                                            _introtext = __introtext
                                            _createdon = __createdon
                                            if let __editedon = json["editedon"] as? String {
                                            _editedon = __editedon
                                            } else if let __editedon = json["editedon"] as? Int {
                                                _editedon = ""
                                            }
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
        Published __publ:Bool, Introtext __intro:String, CreatedOn __created:String, EditedOn __edited:String) {
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
    public func getDescription()->String {
        return _description
    }
    public func getParent()->Int {
        return _parent
    }
    public func getTitle()->String {
        return _title
    }
    public func getContent()->String {
        return _content
    }
    public func getIntrotext()->String {
        return _introtext
    }
    public func isPublished()->Bool {
        return _published
    }
    public func getCreationDate()->String {
        return _createdon
    }
    public func getEditDate()->String {
        return _editedon
    }
    //конвертирует докумен обратно в json объект(для кеширования)
    public func back()->[String:AnyObject] {
        return ["object":[
                            "id":getID(),
                            "parent":getParent(),
                            "pagetitle":getTitle(),
                            "description":getDescription(),
                            "published":isPublished(),
                            "introtext":getIntrotext(),
                            "createdon":getCreationDate(),
                            "editedon":getEditDate(),
                            "parent":getParent(),
                            "content":getContent()]]
    }
}
//минифицированная версия документа для списка курсов(только заголовок и id)
public class SmallDocument {
    private var _id = 0;
    private var _title = "";
    private var _parent = 0;
    private var _empty = false;
    private var _deleted = false;
    private var _publishedon = 0;
    private func initwj(json:[NSObject:AnyObject]) {
        if json["id"]==nil || json["pagetitle"]==nil || json["parent"]==nil ||
            json["empty"]==nil || json["deleted"]==nil || json["publishedon"]==nil {
            exit(42)
        }
        _id = json["id"] as Int
        _title = json["pagetitle"] as String
        _parent = json["parent"] as Int
        _empty = json["empty"] as Bool
        _deleted = json["deleted"] as Bool
        _publishedon = json["publishedon"] as Int
    }
    public init(_json:String) {
        var err: NSError?
        var json = NSJSONSerialization.JSONObjectWithData(_json.dataUsingEncoding(NSUTF8StringEncoding)!, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
        initwj(json)
    }
    public init(WithJSON json:[NSObject:AnyObject]) {
        initwj(json)
    }
    public init() {}
    public func getID()->Int {
        return _id
    }
    public func getTitle()->String {
        return _title
    }
    public func getParent()->Int {
        return _parent
    }
    public func isEmpty()->Bool {
        return _empty
    }
    public func isDeleted()->Bool {
        return _deleted
    }
    public func getPublishedOn()->Int {
        return _publishedon
    }
    public func needed()->Bool {
        return !isEmpty() && !isDeleted()
    }
    public func back()->[NSObject:AnyObject] {
        return ["id":getID(),"pagetitle":getTitle(),"parent":getParent(),"empty":isEmpty(),"deleted":isDeleted(),"publishedon":getPublishedOn()];
    }
}

//для хранения списка статей(без текста?)
public class DocumentsList {
    private var docs:[SmallDocument];
    private var tree:DocTree;
    public init(RawJSON rawJson:String) {
        if(rawJson.isEmpty) {
            //TODO: обрабатывать тут пустую строку
            docs = [SmallDocument]()
            tree = DocTree(root: SmallDocument())
            println("Empty server response")
            return;
        } else {
        var err: NSError?
        var json = NSJSONSerialization.JSONObjectWithData(rawJson.dataUsingEncoding(NSUTF8StringEncoding)!, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
        println(rawJson)
        if let count = json["total"] as? NSInteger {
            
            if let results = json["results"] as? [NSDictionary]{
                docs = results.map({SmallDocument(WithJSON: $0 as NSDictionary)})//лямбда-магия)
                tree = DocTree(root: SmallDocument(WithJSON: ["id":0,"parent":0,"pagetitle":"Меню","empty":true,"deleted":false,"publishedon":0]));
                tree.addRange(docs)
               // tree.print()
                return;
            }
        }
        
        exit(42);
        }
    }
    public init(json:[NSObject:AnyObject]) {
        if let count = json["total"] as? NSInteger {
            
            if let results = json["results"] as? [NSDictionary]{
                docs = results.map({SmallDocument(WithJSON: $0 as NSDictionary)})//и еще лямбда магия
                tree = DocTree(root: SmallDocument(WithJSON: ["id":0,"parent":0,"pagetitle":"Меню","empty":true,"deleted":false,"publishedon":0]));
                tree.addRange(docs)
                return;
            }
        }
        exit(42);
    }
    public init(){ docs = [SmallDocument](); tree=DocTree(root:SmallDocument())}
    public func count()->Int {
        return docs.count
    }
    public func at(_i:Int)->SmallDocument {
        let x  = docs[_i]
        return x
    }
    public func getTree()->DocTree {
        return tree
    }
    public func asCollection()->[SmallDocument] {
        return docs
    }
    public func back()->[NSObject:AnyObject] {
        return ["total":docs.count,"results":docs.map({$0.back()})]//немного лямбда магии :))
    }
}

public class TreeNode {
    public var parent : TreeNode?;
    public var value = SmallDocument();
    public var children = [TreeNode]();
    public init(parent:TreeNode?, value: SmallDocument, children: [TreeNode]) {
        self.parent = parent
        self.value = value
        self.children = children
    }
    public func pathTo()->String {
        var path = "", join = " > "
        var current:TreeNode? = self
        path = current!.value.getTitle()
        current = current?.parent
        while(current != nil && current!.value.getID() != 2) {
            path = current!.value.getTitle() + join + path
            current = current!.parent
        }
        return path
    }
}

public class DocTree {
    var tree: TreeNode;
    init(root:SmallDocument) {
        tree  = TreeNode(parent: nil, value: root, children: [])
    }
    func add(t:SmallDocument)->Bool {
        return add(t,current: tree)
    }
 /*   func print() {
    dispatch_async(dispatch_get_main_queue(), {
        //0  уровень
        println(self.tree.value.getTitle())
        var prev = self.tree.value.getTitle()+" ---> "
        //1 уровень
        for(val) in self.tree.children/*.filter({!$0.children.isEmpty})*/ {
            var s = prev+val.value.getTitle()
            println( s )
        }
        //2 уровень
        for (val1) in self.tree.children {
            var prev2 = prev+val1.value.getTitle() + " ---> "
            for (val2) in val1.children {
                println( prev2+val2.value.getTitle())
            }
        }
        //3 уровень
        for (val1) in self.tree.children {
            var prev2 = prev+val1.value.getTitle() + " ---> "
            for (val2) in val1.children {
                var prev3 = prev2+val2.value.getTitle() + " ---> "
                for (val3) in val2.children {
                    println( prev3+val3.value.getTitle())
                }
            }
        }
        })
    } */
    func addRange(var ts:[SmallDocument]) {
        while !ts.isEmpty {
            var remove = [Int]()
            for(index,val) in enumerate(ts) {
                if add(val) {
                    remove.append(index)
                }
            }
            remove.sort(>);
            for (val) in remove {
                ts.removeAtIndex(val)
            }
            
        }
    }
    ///функция  для добавления в сформированное дерево
    private func add(t:SmallDocument,current:TreeNode)->Bool {
        if current.value.getID() != t.getParent() {
            for (value) in current.children {
                if add(t,current: value) {
                    return true;
                }
            }
        } else {
            if(current.children.filter({$0.value.getID()==t.getID()}).isEmpty) {
            current.children.append(TreeNode(parent: current, value: t, children: []))
            }
            return true
        }
        return false
    }
    
    func getLayer(lvl:Int)->[TreeNode] {
        return getLayer(lvl, filterID: -1)
    }
    func getLayer(level:Int,filterID:Int)->[TreeNode] {
        if level==1 {
            return tree.children.filter({!$0.children.isEmpty})
        }
        var result = [TreeNode]()
        if level==2 {
            for (val) in tree.children.filter({!$0.children.isEmpty}) {
                if filterID > 0 {
                    if val.value.getID() == filterID {
                        return val.children.filter({$0.value.needed()})
                    }
                } else {
                    result += val.children
                }
            }
            return result.filter({$0.value.needed()});
        }
        return []
    }
    func weNeedToGoDeeper(current:[TreeNode],var already:[TreeNode],left:Int)->[TreeNode] {
        if(left>0) {
        var tmp = [TreeNode]()
        for(val) in current {
            tmp += val.children
        }
            already += tmp
            println("\(already.count) \(tmp.count)")
            return weNeedToGoDeeper(tmp, already: already, left: left-1)
        } else { return already }
    }
    func getAll3Plus()->[TreeNode] {
        var x = weNeedToGoDeeper(tree.children.filter({$0.value.getID()==2}), already: [TreeNode](), left: 5).filter({$0.value.needed()})
        println(x.count)
        return x
    }

}







































