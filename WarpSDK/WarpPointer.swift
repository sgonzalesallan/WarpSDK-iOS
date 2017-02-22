//
//  WarpPointer.swift
//  SwipeRX
//
//  Created by Zonily Jame Pesquera on 06/10/2016.
//
//

import EVReflection

open class WarpPointer<T>: EVObject where T:WarpModel {
    open var id: Int = 0
    open var type: String = ""
    open var className: String = ""
    open var attributes:T = T()
    
    public required init(){
        super.init()
    }
    
    public init(type: String, className: String, id: Int){
        super.init()
        self.type = type
        self.className = className
        self.id = id
    }
    
    override open func setValue(_ value: Any?, forUndefinedKey key: String) {
        switch key {
        case "attributes":
            self.attributes = value as! T
        case "id":
            self.id = value as! Int
        case "className":
            self.className = value as! String
        case "type":
            self.type = value as! String
        default:
            WarpTools.showLog(value, key: key, model: "WarpPointer")
        }
    }
    
    open static func map(className: String, id: Int) -> [String: AnyObject] {
        return ["type":"Pointer" as AnyObject,
                "className":className as AnyObject,
                "id":id as AnyObject]
    }

    open static func map(warpObject object:WarpObject) -> [String: AnyObject] {
        return ["type":"Pointer" as AnyObject,
                "className":object.className as AnyObject,
                "id":object.objectId as AnyObject,
                "attributes":object.objects as AnyObject]
    }
    
    open static func map(warpUser object:WarpUser) -> [String: AnyObject] {
        return ["type":"Pointer" as AnyObject,
                "className":object.className as AnyObject,
                "id":object.objectId as AnyObject,
                "attributes":object.objects as AnyObject]
    }
    
    open static func map(className: String, id: Int, attributes: AnyObject?) -> [String: AnyObject] {
        if attributes != nil {
            return ["type":"Pointer" as AnyObject,
                    "className":className as AnyObject,
                    "id":id as AnyObject,
                    "attributes":attributes!]
        } else {
            return ["type":"Pointer" as AnyObject,
                    "className":className as AnyObject,
                    "id":id as AnyObject]
        }
    }
}
