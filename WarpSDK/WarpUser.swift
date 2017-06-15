//
//  WarpUser.swift
//  SwipeRX
//
//  Created by Zonily Jame Pesquera on 06/10/2016.
//
//

import Foundation

public class WarpUser: WarpUserProtocol {
    internal var param: [String: Any] = [:] {
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
    
    internal var className: String = ""
    
    public var objects: [String: Any] {
        return param
    }
    
    internal var _objectId: Int = 0
    public var objectId: Int {
        return _objectId
    }
    
    internal var _createdAt: String = ""
    public var createdAt: String {
        return _createdAt
    }
    
    internal var _updatedAt: String = ""
    public var updatedAt: String {
        return _updatedAt
    }
    
    internal var _username: String = ""
    public var username: String {
        return _username
    }
    
    internal var _password: String = ""
    public var password: String {
        return _password
    }
    
    internal var _sessionToken: String = ""
    public var sessionToken: String {
        return _sessionToken
    }

    required public init() {
        self.className = "user"
    }
    
    public class func createWithoutData(id: Int) -> WarpUser {
        let user = WarpUser()
        user.param["id"] = id as AnyObject?
        user._objectId = id
        return WarpUser()
    }
    
    func setValues(_ JSON: [String: Any]) {
        self.param = JSON
    }
    
    public func get(object forKey: String) -> Any? {
        return self.param[forKey]
    }
    
    public func set(object value: Any, forKey: String) -> Self {
        switch forKey {
        case "created_at", "updated_at", "id":
            fatalError("This action is not permitted")
        default:
            if value is WarpObject {
                self.param[forKey] = WarpPointer.map(warpObject: value as! WarpObject) as Any?
                return self
            }
            
            if value is WarpUser {
                self.param[forKey] = WarpPointer.map(warpUser: value as! WarpUser) as Any?
                return self
            }
            
            self.param[forKey] = value
            return self
        }
    }
    
    public func save() {
        save { (success, error) in }
    }
    
    public func save(_ completion: @escaping (_ success: Bool, _ error: WarpError?) -> Void) {
        guard let warp = Warp.shared else {
            fatalError("WarpServer is not yet initialized")
        }
        if objectId > 0 {
            let _ = WarpAPI.put(warp.API_ENDPOINT + "users/\(objectId)", parameters: self.objects, headers: warp.HEADER()) { (warpResult) in
                switch warpResult {
                case .success(let JSON):
                    let warpResponse = WarpResponse(json: JSON, result: [String: Any].self)
                    switch warpResponse.statusType {
                    case .success:
                        self.setValues(warpResponse.result!)
                        completion(true, nil)
                    default:
                        completion(true, WarpError(message: warpResponse.message, status: warpResponse.status))
                    }
                case .failure(let error):
                    completion(false, error)
                }
            }
        } else {
            let _ = WarpAPI.post(warp.API_ENDPOINT + "users", parameters: self.objects, headers: warp.HEADER()) { (warpResult) in
                switch warpResult {
                case .success(let JSON):
                    let warpResponse = WarpResponse(json: JSON, result: [String: Any].self)
                    switch warpResponse.statusType {
                    case .success:
                        self.setValues(warpResponse.result!)
                        completion(true, nil)
                    default:
                        completion(true, WarpError(message: warpResponse.message, status: warpResponse.status))
                    }
                case .failure(let error):
                    completion(false, error)
                }
            }
        }
    }
    
    public func setUsername(_ username: String) -> WarpUser {
        _username = username
        param["username"] = username as AnyObject?
        return self
    }
    
    public func setPassword(_ password: String) -> WarpUser {
        _password = password
        param["password"] = password as AnyObject?
        return self
    }
    
    public func login(_ username: String, password: String, completion: @escaping (_ success: Bool, _ error: WarpError?) -> Void) {
        guard let warp = Warp.shared else {
            fatalError("WarpServer is not yet initialized")
        }
        let _ = WarpAPI.post(warp.API_ENDPOINT + "login", parameters: ["username":username,"password":password], headers: warp.HEADER()) { (warpResult) in
            switch warpResult {
            case .success(let JSON):
                let warpResponse = WarpResponse(json: JSON, result: [String: Any].self)
                switch warpResponse.statusType {
                case .success:
                    warpResponse.result!["username"] = username as AnyObject?
                    self.setValues(warpResponse.result!)
                    self.setCurrentUser()
                    completion(true, nil)
                default:
                    completion(true, WarpError(message: warpResponse.message, status: warpResponse.status))
                }
                break
            case .failure(let error):
                completion(false, error)
            }
        }
    }
    
    public func signUp(_ completion: @escaping (_ success: Bool, _ error: WarpError?) -> Void) {
        guard let warp = Warp.shared else {
            fatalError("WarpServer is not yet initialized")
        }
        let _ = WarpAPI.post(warp.API_ENDPOINT + "users", parameters: self.objects, headers: warp.HEADER()) { (warpResult) in
            switch warpResult {
            case .success(let JSON):
                let warpResponse = WarpResponse(json: JSON, result: [String: Any].self)
                switch warpResponse.statusType {
                case .success:
                    self.login(self.username, password: self.password, completion: { (success, error) in
                        completion(success, error)
                    })
                default:
                    completion(true, WarpError(message: warpResponse.message, status: warpResponse.status))
                }
            case .failure(let error):
                completion(false, error)
            }
        }
    }
    
    public func logout(_ completion: @escaping (_ success: Bool, _ error: WarpError?) -> Void) {
        guard let warp = Warp.shared else {
            fatalError("WarpServer is not yet initialized")
        }
        let _ = WarpAPI.get(warp.API_ENDPOINT + "logout", parameters: nil, headers: warp.HEADER()) { (warpResult) in
            switch warpResult {
            case .success(let JSON):
                let warpResponse = WarpResponse(json: JSON, result: [String: Any].self)
                switch warpResponse.statusType {
                case .success:
                    WarpUser.deleteCurrent()
                    completion(true, nil)
                default:
                    completion(true, WarpError(message: warpResponse.message, status: warpResponse.status))
                }
            case .failure(let error):
                completion(false, error)
            }
        }
    }
    
    internal func setCurrentUser() {
        var strings:[String] = []
        for key in self.objects.keys {
            strings.append(key)
        }
        
        UserDefaults.standard.set(strings, forKey: "swrxCurrentUserKeys_rbBEAFVAWFBVWW")
        for (key, value) in self.objects {
            UserDefaults.standard.set(value, forKey: "swrxCurrentUser\(key)_9gehrpnvr2pv3r")
        }
    }
    
    public static func current() -> WarpUser? {
        let user: WarpUser = WarpUser()
        
        let keys: [String] = UserDefaults.standard.array(forKey: "swrxCurrentUserKeys_rbBEAFVAWFBVWW") as! [String]
        if keys.count == 0 {
            return nil
        }
        for key in keys {
            _ = user.set(object: UserDefaults.standard.object(forKey: "swrxCurrentUser\(key)_9gehrpnvr2pv3r")! as Any, forKey: key)
        }
        return user
    }
    
    public static func deleteCurrent() {
        UserDefaults.standard.set([], forKey: "swrxCurrentUserKeys_rbBEAFVAWFBVWW")
        let keys:[String] = UserDefaults.standard.array(forKey: "swrxCurrentUserKeys_rbBEAFVAWFBVWW") as! [String]
        for key in keys {
            UserDefaults.standard.set("", forKey: "swrxCurrentUser\(key)_9gehrpnvr2pv3r")
        }
        
    }
}
