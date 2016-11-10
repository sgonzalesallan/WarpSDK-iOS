//
//  WarpTools.swift
//  Practice
//
//  Created by Zonily Jame Pesquera on 28/10/2016.
//
//

import Alamofire

public class WarpTools {
    public static let CONTENT_TYPE = "application/json"
    public static let dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
    
    public static func showLog(value:AnyObject?, key:String, model:String){
        print("---> setValue '\(value)' for key '\(key)' should be handled. MODEL:\(model)")
    }
    
    public static func toResult(response:Response<AnyObject, NSError>) -> WarpResult {
        guard response.result.isSuccess else {
            return .Failure(WarpError(error: response.result.error!))
        }
        guard let JSON = response.result.value else{
            return .Failure(WarpError(code: .ResponseValueIsNil))
        }
        return .Success(JSON)
    }
    
    public static func dateFormatter() -> NSDateFormatter {
        let formatter = NSDateFormatter()
        formatter.dateFormat = dateFormat
        formatter.dateStyle = NSDateFormatterStyle.MediumStyle
        formatter.timeZone = NSTimeZone(name: "UTC")
        return formatter
    }
}

public enum WarpHeader:String {
    case APIKey = "X-Warp-API-Key"
    case ContentType = "Content-Type"
    case Client = "X-Warp-Client"
    case AppVersion = "X-App-Version"
    case WarpVersion = "X-Warp-Version"
    case Session = "X-Warp-Session-Token"
}

public enum WarpResult {
    case Success(AnyObject)
    case Failure(WarpError)
    
    public var isSuccess:Bool {
        switch self {
        case .Success:
            return true
        case .Failure:
            return false
        }
    }
    
    public func showResult() {
        switch self {
        case .Success(let JSON): print("Success Result: \(JSON)")
        case .Failure(let ERROR): print("Error Result: \(ERROR)")
        }
    }
    
    public func getResult() -> AnyObject {
        switch self {
        case .Success(let JSON): return JSON
        case .Failure(let ERROR): return ERROR
        }
    }
    
    public var isFailure:Bool {
        return !isSuccess
    }
}

public enum WarpOrder:Int {
    case Ascending = 1
    case Descending = -1
}
