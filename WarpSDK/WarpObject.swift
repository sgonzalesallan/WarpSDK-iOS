//
//  WarpObject.swift
//  Practice
//
//  Created by Zonily Jame Pesquera on 28/10/2016.
//
//

import Foundation

public class WarpObject:WarpObjectProtocol {
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
                default:
                    break
                }
            }
        }
    }
    internal var className:String = ""
    public var objects:[String : AnyObject] {
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
    
    public required init(className:String) {
        self.className = className
    }
    
    init(className:String, JSON:Dictionary<String,AnyObject>) {
        self.className = className
        setValues(JSON)
    }
    
    public class func createWithoutData(id id:Int, className:String) -> WarpObject{
        let warpObject = WarpObject(className: className)
        warpObject.param["id"] = id
        return warpObject
    }
    
    internal class func createWithoutData(id id:Int) -> WarpObject{
        let warpObject = WarpObject(className: "")
        warpObject.param["id"] = id
        return warpObject
    }
    
    func setValues(JSON:Dictionary<String,AnyObject>) {
        self.param = JSON
        guard let createdAt:String = JSON["created_at"] as? String else {
            return
        }
        self._createdAt = createdAt
        guard let updatedAt:String = JSON["created_at"] as? String else {
            return
        }
        self._updatedAt = updatedAt
    }
    
    public func setObject(value:AnyObject, forKey key:String) -> WarpObject {
        switch key {
        case "created_at":
            return self
        case "updated_at":
            return self
        case "id":
            return self
        default:
            if value is WarpObject {
                self.param[key] = WarpPointer.map(warpObject: value as! WarpObject)
                return self
            }
            
            if value is WarpUser {
                self.param[key] = WarpPointer.map(warpUser: value as! WarpUser)
                return self
            }
            self.param[key] = value
            return self
        }
    }
    
    public func objectForKey(key:String) -> AnyObject? {
        return self.param[key]
    }
    
    public func destroy() {
        destroy { (success, error) in
            
        }
    }
    
    public func destroy(completion:(success:Bool, error:WarpError?) -> Void) {
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
    
    public func save(completion:(success:Bool, error:WarpError?) -> Void) {
        let warp = Warp.sharedInstance
        guard warp != nil else {
            completion(success: false, error: WarpError(code: .ServerNotInitialized))
            return
        }
        if objectId > 0 {
            WarpAPI.put(warp!.API_ENDPOINT! + "classes/\(className)/\(objectId)", parameters: param, headers: warp!.HEADER()) { (warpResult) in
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
            WarpAPI.post(warp!.API_ENDPOINT! + "classes/\(className)", parameters: param, headers: warp!.HEADER()) { (warpResult) in
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
        }
    }
}
