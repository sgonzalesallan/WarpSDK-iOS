//
//  Warp.swift
//  SwipeRX
//
//  Created by Zonily Jame Pesquera on 06/10/2016.
//
//

import EVReflection
import Alamofire

class Warp {
    static var sharedInstance:Warp?
    var API_ENDPOINT:String?
    private var APPLICATION_VERSION:String?
    var API_KEY:String?
    
    private init(baseURL:String, apiKey:String) {
        API_ENDPOINT = baseURL
        API_KEY = apiKey
    }
    
    static func Initialize(baseURL:String, apiKey:String) {
        Warp.sharedInstance = Warp.init(baseURL: baseURL, apiKey: apiKey)
    }
    
    func HEADER() -> [String : String] {
        return[
            WarpHeader.APIKey.rawValue      : API_KEY!,
            WarpHeader.ContentType.rawValue : WarpTools.CONTENT_TYPE,
            WarpHeader.Session.rawValue     : WarpUser.current() == nil ? "" : WarpUser.current()!.sessionToken,
            WarpHeader.Client.rawValue      : "ios",
            WarpHeader.WarpVersion.rawValue : "1.0.0",
            WarpHeader.AppVersion.rawValue  : NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] == nil ? "0.0.0" : NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as! String
        ]
    }
}



protocol WarpModelProtocol {
    func map() -> [String:AnyObject]
    static func endPoint() -> String
    static func endPoint(id:Int) -> String
}

struct APIResult<T> {
    var hasFailed:Bool = true
    var message:String = ""
    var error:NSError?
    var result:T?
    
    var isSuccess:Bool {
        return !hasFailed
    }
    
    init(hasFailed:Bool, message:String?, result:T){
        self.hasFailed = hasFailed
        self.message = message == nil ? "" : message!
        self.result = result
    }
    
    init(hasFailed:Bool, message:String?){
        self.hasFailed = hasFailed
        self.message = message == nil ? "" : message!
    }
}

public extension NSArray {
    func JSONIFY() -> String {
        let data = try! NSJSONSerialization.dataWithJSONObject(self, options: .PrettyPrinted)
        return String(data:data, encoding: NSUTF8StringEncoding)!
    }
}

public extension NSDictionary {
    func JSONIFY() -> String {
        let data = try! NSJSONSerialization.dataWithJSONObject(self, options: .PrettyPrinted)
        return String(data:data, encoding: NSUTF8StringEncoding)!
    }
}
