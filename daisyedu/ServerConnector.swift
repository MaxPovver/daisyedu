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
    let serviceURL = "http://daisyedu.com/rest/resource";
    var data 
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
