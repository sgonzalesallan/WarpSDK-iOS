//
//  Warp.swift
//  SwipeRX
//
//  Created by Zonily Jame Pesquera on 06/10/2016.
//
//

import Alamofire

public typealias WarpRequest = Alamofire.Request

public typealias WarpDataRequest = Alamofire.DataRequest

open class Warp {
    static var shared: Warp?
    var API_ENDPOINT: String
    fileprivate var APPLICATION_VERSION: String?
    var API_KEY: String
    
    static var HEADERS: [String: String] {
        let warp = Warp.shared!
        var header = [
            WarpHeaderKeys.APIKey.rawValue      : warp.API_KEY,
            WarpHeaderKeys.ContentType.rawValue : WarpTools.CONTENT_TYPE,
            WarpHeaderKeys.Client.rawValue      : "ios",
            WarpHeaderKeys.AppVersion.rawValue  : (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "0.0.0"
        
        ]
        
        if let user = WarpUserDefault.current() {
            header.updateValue(user.sessionToken, forKey: WarpHeaderKeys.Session.rawValue)
        }
        
        return header
    }
    
    fileprivate init(baseURL: String, apiKey: String) {
        
        // TODO: Improve This
        if baseURL.characters.last != "/" {
            API_ENDPOINT = baseURL + "/"
        } else {
            API_ENDPOINT = baseURL
        }
        
        API_KEY = apiKey
    }
    
    open static func Initialize(_ baseURL: String, apiKey: String) {
        Warp.shared = Warp.init(baseURL: baseURL, apiKey: apiKey)
    }
    
    func HEADER() -> [String: String] {
        
        return [
            WarpHeaderKeys.APIKey.rawValue      : API_KEY,
            WarpHeaderKeys.ContentType.rawValue : WarpTools.CONTENT_TYPE,
            WarpHeaderKeys.Session.rawValue     : WarpUser.current() == nil ? "" : WarpUser.current()!.sessionToken,
            WarpHeaderKeys.Client.rawValue      : "ios",
            WarpHeaderKeys.WarpVersion.rawValue : "0.0.2",
            WarpHeaderKeys.AppVersion.rawValue  : (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "0.0.0"
        ]
    }
}

// MARK: - Endpoint Generator
extension Warp {
    func generateEndpoint(_ type: EndpointType) -> String {
        var generatedEndpoint = API_ENDPOINT
        
        switch type {
        case .classes(className: let name, id: let id):
            generatedEndpoint += "classes/\(name)"
            if let id = id {
                generatedEndpoint += "/\(String(describing: id))"
            }
            
        case .functions(endpoint: let endpoint):
            generatedEndpoint += "functions/\(endpoint)"
            
        case .login:
            generatedEndpoint += "login"
            
        case .logout:
            generatedEndpoint += "logout"
            
        case .users(id: let id):
            generatedEndpoint += "users"
            if let id = id {
                generatedEndpoint += "/\(String(describing: id))"
            }
            
        }
        
        return generatedEndpoint
    }
    
    enum EndpointType {
        case classes(className: String, id: Int?)
        case functions(endpoint: String)
        case users(id: Int?)
        case login
        case logout
    }
}

public typealias WarpResultBlock = (Bool, WarpError?) -> Void

protocol WarpObjectInterface {
    var param: [String: Any] { get set }
    var className: String { get set }
    
    var _objectId: Int { get set }
    
    var _createdAt: String { get set }
    
    var _updatedAt: String { get set }
}

extension WarpObjectInterface {
    var objectId: Int { return _objectId }
    
    var createdAt: String { return _createdAt }
    
    var updatedAt: String { return _updatedAt }
    
    var objects: [String: Any] { return param }
}

protocol CanGet {
    func get(object forKey: String) -> Any?
}

protocol CanSet {
    func set(object value: Any, forKey: String) -> Self
}

protocol CanSave {
    func save()
    func save(_ completion: @escaping WarpResultBlock)
}

protocol CanDestroy {
    func destroy()
    func destroy(_ completion: @escaping WarpResultBlock)
}

protocol WarpObjectProtocol: WarpObjectInterface, CanGet, CanSet, CanSave, CanDestroy {
    static func createWithoutData(id: Int, className: String) -> WarpObject
    static func createWithoutData(id: Int) -> WarpObject
    
    init(className: String)
}

extension WarpObjectProtocol where Self: WarpObject {
    
}


public struct APIResult<T> {
    public var hasFailed: Bool = true
    public var message: String = ""
    public var error: Error?
    public var result: T?
    
    public var isSuccess: Bool {
        return !hasFailed
    }
    
    public init(hasFailed: Bool, message: String?, result: T) {
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

