//
//  WarpTools.swift
//  Practice
//
//  Created by Zonily Jame Pesquera on 28/10/2016.
//
//

import Alamofire

class WarpTools {
    static let CONTENT_TYPE = "application/json"
    static let dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
    
    static func showLog(value:AnyObject?, key:String, model:String){
        print("---> setValue '\(value)' for key '\(key)' should be handled. MODEL:\(model)")
    }
    
    static func toResult(response:Response<AnyObject, NSError>) -> WarpResult {
        guard response.result.isSuccess else {
            return .Failure(WarpError(error: response.result.error!))
        }
        guard let JSON = response.result.value else{
            return .Failure(WarpError(code: .ResponseValueIsNil))
        }
        return .Success(JSON)
    }
    
    static func dateFormatter() -> NSDateFormatter {
        let formatter = NSDateFormatter()
        formatter.dateFormat = dateFormat
        formatter.dateStyle = NSDateFormatterStyle.MediumStyle
        formatter.timeZone = NSTimeZone(name: "UTC")
        return formatter
    }
}

enum WarpResponseCode:Int {
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

enum WarpHeader:String {
    case APIKey = "X-Warp-API-Key"
    case ContentType = "Content-Type"
    case Client = "X-Warp-Client"
    case AppVersion = "X-App-Version"
    case WarpVersion = "X-Warp-Version"
    case Session = "X-Warp-Session-Token"
}

enum WarpResult {
    case Success(AnyObject)
    case Failure(WarpError)
    
    var isSuccess:Bool {
        switch self {
        case .Success:
            return true
        case .Failure:
            return false
        }
    }
    
    func showResult() {
        switch self {
        case .Success(let JSON): print("Success Result: \(JSON)")
        case .Failure(let ERROR): print("Error Result: \(ERROR)")
        }
    }
    
    var isFailure:Bool {
        return !isSuccess
    }
}

enum WarpOrder:Int {
    case Ascending = 1
    case Descending = -1
}
