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
    /**********************************/
    private var _image = Optional("")
    private var _coach = Optional("")
    private var _price = Optional("")
    private var _format = Optional("")
    /**********************************/
    public init(_json:String) {
        var err: NSError?
        var json = NSJSONSerialization.JSONObjectWithData(_json.dataUsingEncoding(NSUTF8StringEncoding)!, options: NSJSONReadingOptions.MutableContainers, error: &err) as! NSDictionary
        if !initwj(json as [NSObject : AnyObject]) { exit(42); }
    }
    public init(_json:String, sd:SmallDocument) {
        var err: NSError?
        var json = NSJSONSerialization.JSONObjectWithData(_json.dataUsingEncoding(NSUTF8StringEncoding)!, options: NSJSONReadingOptions.MutableContainers, error: &err) as! NSDictionary
        if !initwj(json as [NSObject : AnyObject]) { exit(42); }
        /*********************************************/
        if getImage() == nil { _image = sd.getImage() }
        if getCoach() == nil { _coach = sd.getCoach() }
        if getPrice() == nil { _price = sd.getPrice() }
        if getFormat() == nil { _format = sd.getFormat() }
        /**********************************************/
    }
    private func initwj(_json:[NSObject:AnyObject])->Bool {
        let json = _json["object"] as! NSDictionary
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
                                            _editedon = json["editedon"] as? String ?? ""
                                            _content = __content
                                            /*****************************************/
                                            _image = json["image"] as? String
                                            _coach = json["coach"] as? String
                                            _price = json["price"] as? String
                                            _format = json["format"] as? String
                                            /*****************************************/
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
        var res = _content
        if getImage() != nil
        {
            res =  "<img src=\"\(getImage()!)\" width=\"100%\">" + res
        }
        if getCoach() != nil  && getPrice() != nil && !getPrice()!.isEmpty{
            if getCoach() != nil {
                res = res + "<br><span>Автор:</span> <a href=\"http://coaches/\(getCoach()!)\"><span>\(s.CoachToStr(getCoach()!)) </span></a>"
            }
            if getFormat() != nil {
                res = res + "<br><span>Формат: \(s.FormatToStr(getFormat()!))</span>"
            }
            if getPrice() != nil {
                res = res + "<br><span>Цена: \(getPrice()!) Р.</span>"
            }
        }
        return res
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
    /*************************************/
    public func getImage()->String? {
        return _image
    }
    public func getCoach()->String? {
        return _coach
    }
    public func getPrice()->String? {
        return _price
    }
    public func getFormat()->String? {
        return _format
    }
    /**************************************/
    //конвертирует документ обратно в json объект(для кеширования)
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
                            "content":getContent(),
                            "image":getImage() ?? "",
                            "coach":getCoach() ?? "",
                            "price":getPrice() ?? "",
                            "format":getFormat() ?? ""]]
    }
}
//минифицированная версия документа для списка курсов(только заголовок и id)
//TODO: добавить поля для "image":"images/GTsTHmkTe0k.jpg","coach":"71","price":"2100","format":"1"
public class SmallDocument {
    private var _id = 0;
    private var _title = "";
    private var _parent = 0;
    private var _empty = false;
    private var _deleted = false;
    private var _publishedon = 0;
    /**********************************/
    private var _image = Optional("")
    private var _coach = Optional("")
    private var _price = Optional("")
    private var _format = Optional("")
    /**********************************/
    private func initwj(json:[NSObject:AnyObject]) {
        if json["id"]==nil || json["pagetitle"]==nil || json["parent"]==nil
            {exit(42);}
        if json["empty"]==nil || json["deleted"]==nil || json["publishedon"]==nil  { exit(42) }
        _id = json["id"] as! Int
        _title = json["pagetitle"] as! String
        _parent = json["parent"] as! Int
        _empty = json["empty"] as! Bool
        _deleted = json["deleted"] as! Bool
        _publishedon = json["publishedon"] as! Int
        /*****************************************/
        _image = json["image"] as? String
        _coach = json["coach"] as? String
        _price = json["price"] as? String
        _format = json["format"] as? String
        /*****************************************/
    }
    public init(_json:String) {
        var err: NSError?
        var json = NSJSONSerialization.JSONObjectWithData(_json.dataUsingEncoding(NSUTF8StringEncoding)!, options: NSJSONReadingOptions.MutableContainers, error: &err) as! NSDictionary
        initwj(json as [NSObject : AnyObject])
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
    /*************************************/
    public func getImage()->String? {
        return _image
    }
    public func getCoach()->String? {
        return _coach
    }
    public func getPrice()->String? {
        return _price
    }
    public func getFormat()->String? {
        return _format
    }
    /**************************************/
    public func back()->[NSObject:AnyObject] {
        return ["id":getID(),"pagetitle":getTitle(),"parent":getParent(),"empty":isEmpty(),"deleted":isDeleted(),"publishedon":getPublishedOn(),"image":getImage() ?? "","coach":getCoach() ?? "","price":getPrice() ?? "","format":getFormat() ?? ""];
        /// optinal ?? someval
        // optional != nil => (optional ?? someval) <=> optional
        // optinal == nil => (optinal ?? someval) <=> someval
    }
    public func asJSONStr()->String {
        var tmp = back();
        var data = NSJSONSerialization.dataWithJSONObject(tmp, options: NSJSONWritingOptions.PrettyPrinted, error: nil)
        return NSString(data: data!,encoding:NSUTF8StringEncoding)! as String
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
        var json = NSJSONSerialization.JSONObjectWithData(rawJson.dataUsingEncoding(NSUTF8StringEncoding)!, options: NSJSONReadingOptions.MutableContainers, error: &err) as! NSDictionary
        println(rawJson)
        if let count = json["total"] as? NSInteger {
            
            if let results = json["results"] as? [NSDictionary]{
                docs = results.map({SmallDocument(WithJSON: $0 as NSDictionary as [NSObject : AnyObject])})//лямбда-магия)
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
                docs = results.map({SmallDocument(WithJSON: $0 as NSDictionary as [NSObject : AnyObject])})//и еще лямбда магия
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
    public func toString()->String {
        var l = children.map({"\($0.value.getID())"})
        var s = ", ".join(l);
        return "{\"value\":\(value.asJSONStr()),\"children\":[\(s)]}"
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
    func addRange(var ts:[SmallDocument]) {
        while !ts.isEmpty {
            var remove = [Int]()
            for(index,val) in enumerate(ts) {
                if add(val) {
                    remove.append(index)
                }
            }
            remove.sort(>);//лямбда-магия
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
    private var layerCache:[Int:[TreeNode]] = [Int:[TreeNode]]();
    private var filteredLayerCache:[Int:[Int:[TreeNode]]] = [Int:[Int:[TreeNode]]]();
    func getLayer(lvl:Int)->[TreeNode] {
        return getLayer(lvl, filterID: -1)
    }
    func getLayer(level:Int,filterID:Int)->[TreeNode] {
        if level==1 {
            if layerCache.indexForKey(1) == nil {
                layerCache[1] = tree.children.filter({!$0.children.isEmpty})
            }
            return layerCache[1]!
        }
        if level==2 {
            if filteredLayerCache[2]==nil {
                filteredLayerCache[2] = [Int:[TreeNode]]()
            }
            if (filterID <= 0) {
                    if layerCache.indexForKey(2) == nil {
                        var tmp =  tree.children.filter({!$0.children.isEmpty})
                        var res:[TreeNode] = []
                        for (v) in tmp {
                            res += v.children
                        }
                        layerCache[2] = res.filter({$0.value.needed()})
                    }
                    return layerCache[2]!
                }  else if filteredLayerCache[2]?.indexForKey(filterID) == nil {
                            var tmp = [TreeNode]()
                            for (val) in tree.children.filter({!$0.children.isEmpty}) {
                                if val.value.getID() == filterID {
                                    filteredLayerCache[2]![filterID] = val.children.filter({$0.value.needed()})
                                    return filteredLayerCache[2]![filterID]!
                                }
                        }
            }
            return filteredLayerCache[2]![filterID]!
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
     var getAll3PlusCache:[TreeNode]=[TreeNode]()
    func getAll3Plus()->[TreeNode] {
        if (getAll3PlusCache.isEmpty)
        { getAll3PlusCache = weNeedToGoDeeper(tree.children.filter({$0.value.getID()==2}), already: [TreeNode](), left: 5).filter({$0.value.needed()})
        }
        return getAll3PlusCache
    }
    func getForID(id:Int)->TreeNode? {
        for (v) in getLayer(2) {
            if v.value.getID() == id {
                return v
            }
        }
        for (v) in getAll3Plus() {
            if v.value.getID() == id {
                return v
            }
        }
        return nil
    }
    //удаляет все кешированные данные
     func DropCaches() {
        getAll3PlusCache.removeAll(keepCapacity: false)
        layerCache.removeAll(keepCapacity: false)
        filteredLayerCache.removeAll(keepCapacity: false)
    }
    func toString() {
        
    }
}



func print(var n:[TreeNode]) {
    print("{")
    if(n.count>0) {
        var tmp = n.map({"\($0.toString())"})
        print(", ".join(tmp))
    }
    print("}")
}
    



































