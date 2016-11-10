//
//  Warp.swift
//  SwipeRX
//
//  Created by Zonily Jame Pesquera on 06/10/2016.
//
//

//import EVReflection
import Alamofire

public class Warp {
    static var sharedInstance:Warp?
    var API_ENDPOINT:String?
    private var APPLICATION_VERSION:String?
    var API_KEY:String?
    
    private init(baseURL:String, apiKey:String) {
        API_ENDPOINT = baseURL
        API_KEY = apiKey
    }
    
    public static func Initialize(baseURL:String, apiKey:String) {
        Warp.sharedInstance = Warp.init(baseURL: baseURL, apiKey: apiKey)
    }
    
    func HEADER() -> [String : String] {
        return[
            WarpHeader.APIKey.rawValue      : API_KEY!,
            WarpHeader.ContentType.rawValue : WarpTools.CONTENT_TYPE,
            WarpHeader.Session.rawValue     : WarpUser.current() == nil ? "" : WarpUser.current()!.sessionToken,
            WarpHeader.Client.rawValue      : "ios",
            WarpHeader.WarpVersion.rawValue : "0.0.2",
            WarpHeader.AppVersion.rawValue  : NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] == nil ? "0.0.0" : NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as! String
        ]
    }
}

typealias WarpCompletion = (success:Bool, error:WarpError?) -> Void

protocol WarpObjectProtocol {
    var param:[String : AnyObject] { get set }
    var className:String { get set }
    var objects:[String : AnyObject] { get }
    
    var _objectId:Int { get set }
    var objectId:Int { get }
    
    var _createdAt:String { get set }
    var createdAt:String { get }
    
    var _updatedAt:String { get set }
    var updatedAt:String { get }
    
    static func createWithoutData(id id:Int, className:String) -> WarpObject
    static func createWithoutData(id id:Int) -> WarpObject
    
    init(className:String)
    
    func setObject(value:AnyObject, forKey:String) -> WarpObject
    
    func objectForKey(key:String) -> AnyObject?
    
    func destroy()
    
    func destroy(completion:WarpCompletion)
    
    func save()
    
    func save(completion:WarpCompletion)
}

protocol WarpUserProtocol {
    var param:[String : AnyObject] { get set }
    var className:String { get set }
    var objects:[String : AnyObject] { get }
    
    var _objectId:Int { get set }
    var objectId:Int { get }
    
    var _createdAt:String { get set }
    var createdAt:String { get }
    
    var _updatedAt:String { get set }
    var updatedAt:String { get }
    
    static func createWithoutData(id id:Int) -> WarpUser
    
    init()
    
    func setObject(value:AnyObject, forKey:String) -> WarpUser
    
    func objectForKey(key:String) -> AnyObject?
    
    func save()
    func save(completion:WarpCompletion)
    
    
    var _username:String { get set }
    var username:String { get }
    var _password:String { get set }
    var password:String { get }
    var _sessionToken:String { get set }
    var sessionToken:String { get }
    
    func setUsername(username:String) -> WarpUser
    func setPassword(password:String) -> WarpUser
    
    func login(username:String, password:String, completion:WarpCompletion)
    func signUp(completion:WarpCompletion)
    func logout(completion:WarpCompletion)
    
    static func current() -> WarpUser?
    static func deleteCurrent()
    func setCurrentUser()
}

public protocol WarpModelProtocol {
    func map() -> [String:AnyObject]
    static func endPoint() -> String
    static func endPoint(id:Int) -> String
}

public struct APIResult<T> {
    public var hasFailed:Bool = true
    public var message:String = ""
    public var error:NSError?
    public var result:T?
    
    public var isSuccess:Bool {
        return !hasFailed
    }
    
    public init(hasFailed:Bool, message:String?, result:T){
        self.hasFailed = hasFailed
        self.message = message == nil ? "" : message!
        self.result = result
    }
    
    public init(hasFailed:Bool, message:String?){
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
