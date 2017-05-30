//
//  Warp.swift
//  SwipeRX
//
//  Created by Zonily Jame Pesquera on 06/10/2016.
//
//

import Alamofire



open class Warp {
    static var sharedInstance:Warp?
    var API_ENDPOINT: String?
    fileprivate var APPLICATION_VERSION: String?
    var API_KEY: String?
    
    fileprivate init(baseURL: String, apiKey: String) {
        API_ENDPOINT = baseURL
        API_KEY = apiKey
    }
    
    open static func Initialize(_ baseURL: String, apiKey: String) {
        Warp.sharedInstance = Warp.init(baseURL: baseURL, apiKey: apiKey)
    }
    
    func HEADER() -> [String : String] {
        return[
            WarpHeaderKeys.APIKey.rawValue      : API_KEY!,
            WarpHeaderKeys.ContentType.rawValue : WarpTools.CONTENT_TYPE,
            WarpHeaderKeys.Session.rawValue     : WarpUser.current() == nil ? "" : WarpUser.current()!.sessionToken,
            WarpHeaderKeys.Client.rawValue      : "ios",
            WarpHeaderKeys.WarpVersion.rawValue : "0.0.2",
            WarpHeaderKeys.AppVersion.rawValue  : Bundle.main.infoDictionary?["CFBundleShortVersionString"] == nil ? "0.0.0" : Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
        ]
    }
}

public typealias WarpResultSet = (Bool, WarpError?)

protocol WarpObjectProtocol {
    var param: [String: Any] { get set }
    var className: String { get set }
    var objects: [String: Any] { get }
    
    var _objectId: Int { get set }
    var objectId: Int { get }
    
    var _createdAt: String { get set }
    var createdAt: String { get }
    
    var _updatedAt: String { get set }
    var updatedAt: String { get }
    
    static func createWithoutData(id: Int, className: String) -> WarpObject
    static func createWithoutData(id: Int) -> WarpObject
    
    init(className: String)
    
    func set(object value: Any, forKey: String) -> WarpObject
    
    func get(object forKey: String) -> Any?
    
    func destroy()
    
    func destroy(_ completion: @escaping (_ result: WarpResultSet) -> Void)
    
    func save()
    
    func save(_ completion: @escaping (_ result: WarpResultSet) -> Void)
}

protocol WarpUserProtocol {
    var param: [String: Any] { get set }
    var className: String { get set }
    var objects: [String: Any] { get }
    
    var _objectId: Int { get set }
    var objectId: Int { get }
    
    var _createdAt: String { get set }
    var createdAt: String { get }
    
    var _updatedAt: String { get set }
    var updatedAt: String { get }
    
    static func createWithoutData(id: Int) -> WarpUser
    
    init()
    
    func set(object value: Any, forKey: String) -> WarpUser
    
    func get(object forKey: String) -> Any?
    
    func save()
    func save(_ completion: @escaping (_ result: WarpResultSet) -> Void)
    
    
    var _username: String { get set }
    var username: String { get }
    var _password: String { get set }
    var password: String { get }
    var _sessionToken: String { get set }
    var sessionToken: String { get }
    
    func setUsername(_ username: String) -> WarpUser
    func setPassword(_ password: String) -> WarpUser
    
    func login(_ username: String, password: String, completion: @escaping (_ result: WarpResultSet) -> Void)
    func signUp(_ completion: @escaping (_ result: WarpResultSet) -> Void)
    func logout(_ completion: @escaping (_ result: WarpResultSet) -> Void)
    
    static func current() -> WarpUser?
    static func deleteCurrent()
    func setCurrentUser()
}

public protocol WarpModelProtocol {
    var className: String { get }
    
    func map() -> [String: Any]
    
    static func endPoint() -> String
    
    static func endPoint(_ id: Int) -> String
}

public struct APIResult<T> {
    public var hasFailed: Bool = true
    public var message: String = ""
    public var error: Error?
    public var result: T?
    
    
    public var isSuccess: Bool {
        return !hasFailed
    }
    
    public init(hasFailed: Bool, message: String?, result: T){
        self.hasFailed = hasFailed
        self.message = message ?? ""
        self.result = result
    }
    
    public init(hasFailed: Bool, message: String?){
        self.hasFailed = hasFailed
        self.message = message ?? ""
    }
    
    public init(hasFailed: Bool, message: String?, error: Error?){
        self.hasFailed = hasFailed
        self.message = message ?? ""
        self.error = error
    }
}
