//
//  WarpUser.swift
//  SwipeRX
//
//  Created by Zonily Jame Pesquera on 06/10/2016.
//
//

import Foundation

public class WarpUser:WarpUserProtocol {
    internal var param:[String : AnyObject] = [:] {
        didSet {
            for (key, value) in param {
                switch key {
                case "id":
                    _objectId = value as! Int
                case "created_at":
                    _createdAt = value as! String
                case "updated_at":
                    _updatedAt = value as! String
                case "session_token":
                    _sessionToken = value as! String
                default:
                    break
                }
            }
        }
    }
    
    internal var className:String = ""
    var objects:[String : AnyObject] {
        return param
    }
    
    internal var _objectId:Int = 0
    public var objectId:Int {
        return _objectId
    }
    
    internal var _createdAt:String = ""
    public var createdAt:String {
        return _createdAt
    }
    
    internal var _updatedAt:String = ""
    public var updatedAt:String {
        return _updatedAt
    }
    
    internal var _username:String = ""
    public var username:String {
        return _username
    }
    
    internal var _password:String = ""
    public var password:String {
        return _password
    }
    
    internal var _sessionToken:String = ""
    public var sessionToken:String {
        return _sessionToken
    }

    required public init() {
        self.className = "user"
    }
    
    init(className:String, JSON:Dictionary<String,AnyObject>) {
        self.className = className
        setValues(JSON)
    }
    
    public class func createWithoutData(id id:Int) -> WarpUser {
        let user = WarpUser()
        user.param["id"] = id
        user._objectId = id
        return WarpUser()
    }
    
    func setValues(JSON:Dictionary<String,AnyObject>) {
        self.param = JSON
    }
    
    public func setObject(value:AnyObject, forKey key:String) -> WarpUser {
        if value is WarpObject {
            let warpObject = value as! WarpObject
            self.param[key] = WarpPointer.map(className: warpObject.className, id: warpObject.objectId)
            return self
        }
        self.param[key] = value
        return self
    }
    
    internal class func createWithoutData(id id: Int, className: String) -> WarpUser {
        return createWithoutData(id: id)
    }
    
    public func objectForKey(key:String) -> AnyObject? {
        return self.param[key]
    }
    
    internal func destroy() {
        destroy { (success, error) in
            
        }
    }
    
    func destroy(completion:(success:Bool, error:WarpError?) -> Void) {
        let warp = Warp.sharedInstance
        guard warp != nil else {
            completion(success: false, error: WarpError(code: .ServerNotInitialized))
            return
        }
        if objectId > 0 {
            WarpAPI.delete(warp!.API_ENDPOINT! + "classes/\(className)/\(objectId)", parameters: param, headers: warp!.HEADER()) { (warpResult) in
                switch warpResult {
                case .Success(let JSON):
                    let warpResponse = WarpResponse(JSON: JSON, result: Dictionary<String,AnyObject>.self)
                    switch warpResponse.statusType {
                    case .Success:
                        self.setValues(warpResponse.result!)
                        completion(success: true, error: nil)
                    default:
                        completion(success: true, error: WarpError(message: warpResponse.message, status: warpResponse.status))
                    }
                    break
                case .Failure(let error):
                    completion(success: false, error: error)
                }
            }
        } else {
            completion(success: false, error: WarpError(code: .ObjectDoesNotExist))
        }
    }
    
    public func save() {
        save { (success, error) in
            
        }
    }
    
    public func save(completion: (success: Bool, error: WarpError?) -> Void) {
        let warp = Warp.sharedInstance
        guard warp != nil else {
            completion(success: false, error: WarpError(code: .ServerNotInitialized))
            return
        }
        if objectId > 0 {
            WarpAPI.put(warp!.API_ENDPOINT! + "users/\(objectId)", parameters: self.objects, headers: warp!.HEADER()) { (warpResult) in
                switch warpResult {
                case .Success(let JSON):
                    let warpResponse = WarpResponse(JSON: JSON, result: Dictionary<String,AnyObject>.self)
                    switch warpResponse.statusType {
                    case .Success:
                        self.setValues(warpResponse.result!)
                        completion(success: true, error: nil)
                    default:
                        completion(success: true, error: WarpError(message: warpResponse.message, status: warpResponse.status))
                    }
                case .Failure(let error):
                    completion(success: false, error: error)
                }
            }
        } else {
            WarpAPI.post(warp!.API_ENDPOINT! + "users", parameters: self.objects, headers: warp!.HEADER()) { (warpResult) in
                switch warpResult {
                case .Success(let JSON):
                    let warpResponse = WarpResponse(JSON: JSON, result: Dictionary<String,AnyObject>.self)
                    switch warpResponse.statusType {
                    case .Success:
                        self.setValues(warpResponse.result!)
                        completion(success: true, error: nil)
                    default:
                        completion(success: true, error: WarpError(message: warpResponse.message, status: warpResponse.status))
                    }
                case .Failure(let error):
                    completion(success: false, error: error)
                }
            }
        }
    }
    
    
   public  func setUsername(username:String) -> WarpUser {
        _username = username
        param["username"] = password
        return self
    }
    
    public func setPassword(password:String) -> WarpUser {
        _password = password
        param["password"] = password
        return self
    }
    
    
    init(JSON:Dictionary<String,AnyObject>) {
//        super.init(className: "user", JSON: JSON)
    }
    
    func login(username:String, password:String, completion: (success: Bool, error: WarpError?) -> Void) {
        let warp = Warp.sharedInstance
        guard warp != nil else {
            completion(success: false, error: WarpError(code: .ServerNotInitialized))
            return
        }
        WarpAPI.post(warp!.API_ENDPOINT! + "login", parameters: ["username":username,"password":password], headers: warp!.HEADER()) { (warpResult) in
            switch warpResult {
            case .Success(let JSON):
                let warpResponse = WarpResponse(JSON: JSON, result: Dictionary<String,AnyObject>.self)
                switch warpResponse.statusType {
                case .Success:
                    warpResponse.result!["username"] = username
                    self.setValues(warpResponse.result!)
                    self.setCurrentUser()
                    completion(success: true, error: nil)
                default:
                    completion(success: true, error: WarpError(message: warpResponse.message, status: warpResponse.status))
                }
                break
            case .Failure(let error):
                completion(success: false, error: error)
            }
        }
    }
    
    func signUp(completion: (success: Bool, error: WarpError?) -> Void) {
        let warp = Warp.sharedInstance
        guard warp != nil else {
            completion(success: false, error: WarpError(code: .ServerNotInitialized))
            return
        }
        WarpAPI.post(warp!.API_ENDPOINT! + "users", parameters: self.objects, headers: warp!.HEADER()) { (warpResult) in
            switch warpResult {
            case .Success(let JSON):
                let warpResponse = WarpResponse(JSON: JSON, result: Dictionary<String,AnyObject>.self)
                switch warpResponse.statusType {
                case .Success:
                    self.login(self.username, password: self.password, completion: { (success, error) in
                        completion(success: success, error: error)
                    })
                default:
                    completion(success: true, error: WarpError(message: warpResponse.message, status: warpResponse.status))
                }
            case .Failure(let error):
                completion(success: false, error: error)
            }
        }
    }

    func logout(completion: (success: Bool, error: WarpError?) -> Void) {
        let warp = Warp.sharedInstance
        guard warp != nil else {
            completion(success: false, error: WarpError(code: .ServerNotInitialized))
            return
        }
        WarpAPI.get(warp!.API_ENDPOINT! + "logout", parameters: nil, headers: warp!.HEADER()) { (warpResult) in
            switch warpResult {
            case .Success(let JSON):
                let warpResponse = WarpResponse(JSON: JSON, result: Dictionary<String,AnyObject>.self)
                switch warpResponse.statusType {
                case .Success:
                    WarpUser.deleteCurrent()
                    completion(success: true, error: nil)
                default:
                    completion(success: true, error: WarpError(message: warpResponse.message, status: warpResponse.status))
                }
            case .Failure(let error):
                completion(success: false, error: error)
            }
        }
    }
    
    internal func setCurrentUser() {
        var strings:[String] = []
        for key in self.objects.keys {
            strings.append(key)
        }
        NSUserDefaults.standardUserDefaults().setObject(strings, forKey: "swrxCurrentUserKeys_rbBEAFVAWFBVWW")
        for (key, value) in self.objects {
            NSUserDefaults.standardUserDefaults().setObject(value, forKey: "swrxCurrentUser\(key)_9gehrpnvr2pv3r")
        }
    }
    
    public static func current() -> WarpUser? {
        let user:WarpUser = WarpUser()
        let keys:[String] = NSUserDefaults.standardUserDefaults().arrayForKey("swrxCurrentUserKeys_rbBEAFVAWFBVWW") as! [String]
        if keys.count == 0 {
            return nil
        }
        for key in keys {
            user.setObject(NSUserDefaults.standardUserDefaults().objectForKey("swrxCurrentUser\(key)_9gehrpnvr2pv3r")!, forKey: key)
        }
        return user
    }
    
    public static func deleteCurrent() {
        NSUserDefaults.standardUserDefaults().setObject([], forKey: "swrxCurrentUserKeys_rbBEAFVAWFBVWW")
        let keys:[String] = NSUserDefaults.standardUserDefaults().arrayForKey("swrxCurrentUserKeys_rbBEAFVAWFBVWW") as! [String]
        for key in keys {
            NSUserDefaults.standardUserDefaults().setObject("", forKey: "swrxCurrentUser\(key)_9gehrpnvr2pv3r")
        }
        
    }
}
