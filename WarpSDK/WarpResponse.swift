//
//  AuthResponse.swift
//  SwipeRX
//
//  Created by Zonily Jame on 13/07/2016.
//
//

import EVReflection

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

public enum WarpResponseCode:Int {
    case Success = 200
    case MissingConfiguration = 300
    case InternalServerError = 100
    case QueryError = 101
    case InvalidCredentials = 102
    case InvalidSessionToken = 103
    case InvalidObjectKey = 104
    case InvalidPointer = 105
    case ForbiddenOperation = 106
    case UsernameTaken = 107
    case EmailTaken = 108
    case InvalidAPIKey = 109
    case ModelNotFound = 110
    case FunctionNotFound = 111
    case Other
    
    init(int:Int) {
        switch int {
        case 200: self = .Success
        case 300: self = .MissingConfiguration
        case 100: self = .InternalServerError
        case 101: self = .QueryError
        case 102: self = .InvalidCredentials
        case 103: self = .InvalidSessionToken
        case 104: self = .InvalidObjectKey
        case 105: self = .ForbiddenOperation
        case 106: self = .UsernameTaken
        case 107: self = .UsernameTaken
        case 108: self = .EmailTaken
        case 109: self = .InvalidAPIKey
        case 110: self = .ModelNotFound
        case 111: self = .FunctionNotFound
        default: self = .Other
        }
    }
}
