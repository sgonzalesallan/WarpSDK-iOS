//
//  WarpUser.swift
//  SwipeRX
//
//  Created by Zonily Jame Pesquera on 06/10/2016.
//
//

import Foundation

class WarpUser:WarpObject {
    private var _username:String = ""
    private var _password:String = ""
    private var _sessionToken:String = ""
    var username:String {
        return _username
    }
    var password:String {
        return _password
    }
    var sessionToken:String {
        return _sessionToken
    }
    
    func setUsername(username:String) -> WarpUser {
        setObject(username, forKey: "username")
        return self
    }
    
    func setPassword(password:String) -> WarpUser {
        setObject(password, forKey: "password")
        return self
    }
    
    init() {
        super.init(className: "user")
    }
    
    init(JSON:Dictionary<String,AnyObject>) {
        super.init(className: "user", JSON: JSON)
    }
    
    override func setObject(value:AnyObject, forKey key:String) -> WarpObject {
        switch key {
        case "session_token":
            _sessionToken = value as! String
        case "username":
            _username = value as! String
        case "password:":
            _password = value as! String
        default:
            break
        }
        return super.setObject(value, forKey: key)
    }
    
    override func setValues(JSON: Dictionary<String, AnyObject>) {
        var anotherJSON: Dictionary<String, AnyObject> = [:]
        self._sessionToken = JSON["session_token"] as! String
        anotherJSON["id"] = JSON["user"]!["id"]
        anotherJSON["session_token"] = JSON["session_token"]
        anotherJSON["username"] = JSON["username"]
        super.setValues(anotherJSON)
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
    
    override func destroy() {
        destroy { (success, error) in
            
        }
    }
    
    override func destroy(completion: (success: Bool, error: WarpError?) -> Void) {
        let warp = Warp.sharedInstance
        guard warp != nil else {
            completion(success: false, error: WarpError(code: .ServerNotInitialized))
            return
        }
    }
    
    static func createWithoutData(id id:Int) -> WarpUser {
        //DO THIS OMG
        return WarpUser()
    }
    
    override func save() {
        save { (success, error) in
            
        }
    }
    
    override func save(completion: (success: Bool, error: WarpError?) -> Void) {
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
}

//Defaults
extension WarpUser {
    private func setCurrentUser() {
        var strings:[String] = []
        for key in self.objects.keys {
            strings.append(key)
        }
        NSUserDefaults.standardUserDefaults().setObject(strings, forKey: "swrxCurrentUserKeys_rbBEAFVAWFBVWW")
        for (key, value) in self.objects {
            NSUserDefaults.standardUserDefaults().setObject(value, forKey: "swrxCurrentUser\(key)_9gehrpnvr2pv3r")
        }
    }
    
    static func current() -> WarpUser? {
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
    
    static func deleteCurrent() {
        NSUserDefaults.standardUserDefaults().setObject([], forKey: "swrxCurrentUserKeys_rbBEAFVAWFBVWW")
        let keys:[String] = NSUserDefaults.standardUserDefaults().arrayForKey("swrxCurrentUserKeys_rbBEAFVAWFBVWW") as! [String]
        for key in keys {
            NSUserDefaults.standardUserDefaults().setObject("", forKey: "swrxCurrentUser\(key)_9gehrpnvr2pv3r")
        }
        
    }
}
