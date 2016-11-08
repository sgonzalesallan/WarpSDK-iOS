//
//  WarpObject.swift
//  SwipeRX
//
//  Created by Zonily Jame Pesquera on 06/10/2016.
//
//

//import EVReflection

class WarpModel: EVObject, WarpModelProtocol {
    var id:Int = 0
    var createdAt:String = ""
    var updatedAt:String = ""
    
    required init(){
        super.init()
    }
    
    override func setValue(value: AnyObject!, forUndefinedKey key: String) {
        switch key {
        case "created_at":
            self.createdAt = value as! String
        case "updated_at":
            self.updatedAt = value as! String
        default:
            WarpTools.showLog(value, key: key, model: "WarpObject")
        }
    }
    
    class func endPoint() -> String {
        return ""
    }
    
    class func endPoint(id: Int) -> String {
        return ""
    }
    
    func map() -> [String : AnyObject] {
        return ["":""]
    }
}

class EVObject:NSObject {
    override required init() {
        
    }
}
