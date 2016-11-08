//
//  AuthResponse.swift
//  SwipeRX
//
//  Created by Zonily Jame on 13/07/2016.
//
//

//import EVReflection
class WarpResponse<T>:EVObject {
    var message:String = ""
    var result:T?
    var status:Int = 0
    var statusType:WarpResponseCode = .Other
    
    init(setMessage message:String, setResult result:T?, setStatus status:Int){
        self.message = message;
        self.result = result
        self.status = status
    }
    
    required init(){
        super.init()
    }
    
    init(JSON:AnyObject, result:T.Type) {
        self.message = JSON["message"] as! String
        self.result = JSON["result"] as? T
        self.status = JSON["status"] as! Int
        self.statusType = WarpResponseCode(int: status)
    }
    
    init(JSON:AnyObject) {
        self.message = JSON["message"] as! String
        self.result = nil
        self.status = JSON["status"] as! Int
        self.statusType = WarpResponseCode(int: status)
    }
}
