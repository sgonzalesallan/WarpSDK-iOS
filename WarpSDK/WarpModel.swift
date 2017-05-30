//
//  WarpObject.swift
//  SwipeRX
//
//  Created by Zonily Jame Pesquera on 06/10/2016.
//
//

import EVReflection

open class WarpModel: EVObject, WarpModelProtocol {
    open var id: Int = 0
    open var createdAt: String = ""
    open var updatedAt: String = ""
    
    required public init(){
        super.init()
    }
    
    override open func setValue(_ value: Any?, forUndefinedKey key: String) {
        switch key {
        case "created_at":
            self.createdAt = value as! String
        case "updated_at":
            self.updatedAt = value as! String
        default:
            WarpTools.showLog(value, key: key, model: "WarpObject")
        }
    }
    
    open class func endPoint() -> String {
        return ""
    }
    
    open class func endPoint(_ id: Int) -> String {
        return ""
    }
    
    open func map() -> [String : AnyObject] {
        return ["":"" as AnyObject]
    }
}
