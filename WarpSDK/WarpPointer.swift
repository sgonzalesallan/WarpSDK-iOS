//
//  WarpPointer.swift
//  SwipeRX
//
//  Created by Zonily Jame Pesquera on 06/10/2016.
//
//

//import EVReflection

public class WarpPointer<T where T:WarpModel>: EVObject {
    var id:Int = 0
    var type:String = ""
    var className:String = ""
    var attributes:T = T()
    
    public required init(){
        super.init()
    }
    
    public init(type:String, className:String, id:Int){
        super.init()
        self.type = type
        self.className = className
        self.id = id
    }
    
    override public func setValue(value: AnyObject?, forUndefinedKey key: String) {
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
    
    public static func map(className className:String, id:Int) -> [String:AnyObject] {
        return ["type":"Pointer",
                "className":className,
                "id":id]
    }

    public static func map(warpObject object:WarpObject) -> [String:AnyObject] {
        return ["type":"Pointer",
                "className":object.className,
                "id":object.objectId,
                "attributes":object.objects]
    }
    
    public static func map(warpUser object:WarpUser) -> [String:AnyObject] {
        return ["type":"Pointer",
                "className":object.className,
                "id":object.objectId,
                "attributes":object.objects]
    }
    
    public static func map(className className:String, id:Int, attributes:AnyObject?) -> [String:AnyObject] {
        if attributes != nil {
            return ["type":"Pointer",
                    "className":className,
                    "id":id,
                    "attributes":attributes!]
    
        } else {
            return ["type":"Pointer",
                    "className":className,
                    "id":id]
        }
    }
}
