//
//  AuthResponse.swift
//  SwipeRX
//
//  Created by Zonily Jame on 13/07/2016.
//
//

import EVReflection

open class WarpResponse<T>: EVObject {
    open var message: String = ""
    open var result:T?
    open var status: Int = 0
    open var statusType:WarpResponseCode = .other
    
    public init(setMessage message: String, setResult result:T?, setStatus status: Int){
        self.message = message;
        self.result = result
        self.status = status
    }
    
    required public  init(){
        super.init()
    }
    
    public init(JSON: AnyObject, result: T.Type) {
        self.message = JSON["message"] as! String
        self.result = JSON["result"] as? T
        self.status = JSON["status"] as! Int
        self.statusType = WarpResponseCode(int: status)
    }
    
    public init(JSON: AnyObject) {
        self.message = JSON["message"] as! String
        self.result = nil
        self.status = JSON["status"] as! Int
        self.statusType = WarpResponseCode(int: status)
    }
}

public enum WarpResponseCode: Int {
    case success = 200
    case missingConfiguration = 300
    case internalServerError = 100
    case queryError = 101
    case invalidCredentials = 102
    case invalidSessionToken = 103
    case invalidObjectKey = 104
    case invalidPointer = 105
    case forbiddenOperation = 106
    case usernameTaken = 107
    case emailTaken = 108
    case invalidAPIKey = 109
    case modelNotFound = 110
    case functionNotFound = 111
    case other
    
    public init(int: Int) {
        switch int {
        case 200: self = .success
        case 300: self = .missingConfiguration
        case 100: self = .internalServerError
        case 101: self = .queryError
        case 102: self = .invalidCredentials
        case 103: self = .invalidSessionToken
        case 104: self = .invalidObjectKey
        case 105: self = .forbiddenOperation
        case 106: self = .usernameTaken
        case 107: self = .usernameTaken
        case 108: self = .emailTaken
        case 109: self = .invalidAPIKey
        case 110: self = .modelNotFound
        case 111: self = .functionNotFound
        default: self = .other
        }
    }
}
