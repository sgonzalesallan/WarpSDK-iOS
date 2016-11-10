//
//  WarpObject.swift
//  SwipeRX
//
//  Created by Zonily Jame Pesquera on 06/10/2016.
//
//

import EVReflection

public class WarpModel: EVObject, WarpModelProtocol {
    public var id:Int = 0
    public var createdAt:String = ""
    public var updatedAt:String = ""
    
    required public init(){
        super.init()
    }
    
    override public func setValue(value: AnyObject!, forUndefinedKey key: String) {
        switch key {
        case "created_at":
            self.createdAt = value as! String
        case "updated_at":
            self.updatedAt = value as! String
        default:
            WarpTools.showLog(value, key: key, model: "WarpObject")
        }
    }
    
    public class func endPoint() -> String {
        return ""
    }
    
    public class func endPoint(id: Int) -> String {
        return ""
    }
    
    public func map() -> [String : AnyObject] {
        return ["":""]
    }
}
