//
//  WarpObject.swift
//  Practice
//
//  Created by Zonily Jame Pesquera on 28/10/2016.
//
//

import Foundation

class WarpObject {
    private var param:[String : AnyObject] = [:] {
        didSet {
            for (key, value) in param {
                switch key {
                case "id":
                    _objectId = value as! Int
                default:
                    break
                }
            }
        }
    }
    private var className:String = ""
    var objects:[String : AnyObject] {
        return param
    }
    
    private var _objectId:Int = 0
    var objectId:Int {
        return _objectId
    }
    
    private var _createdAt:String = ""
    var createdAt:String {
        return _createdAt
    }
    
    private var _updatedAt:String = ""
    var updatedAt:String {
        return _updatedAt
    }
    
    init(className:String) {
        self.className = className
    }
    
    init(className:String, JSON:Dictionary<String,AnyObject>) {
        self.className = className
        setValues(JSON)
    }
    
    class func createWithoutData(id id:Int, className:String) -> WarpObject{
        let warpObject = WarpObject(className: className)
        warpObject.setObject(id, forKey: "id")
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
    
    func setObject(value:AnyObject, forKey key:String) -> WarpObject {
        if value is WarpObject {
            let warpObject = value as! WarpObject
            self.param[key] = WarpPointer.map(className: warpObject.className, id: warpObject.objectId)
            return self
        }
        self.param[key] = value
        return self
    }
    
    func objectForKey(key:String) -> AnyObject? {
        return self.param[key]
    }
    
    func destroy() {
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
    
    func save() {
        save { (success, error) in
            
        }
    }
    
    func save(completion:(success:Bool, error:WarpError?) -> Void) {
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
