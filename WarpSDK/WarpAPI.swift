//
//  WarpAPI.swift
//  SwipeRX
//
//  Created by Zonily Jame Pesquera on 06/10/2016.
//
//

import Alamofire

open class WarpAPI {
    open static func get(_ URLString: URLConvertible, parameters: [String : Any]?, headers: [String : String], completionHandler: @escaping (_ warpResult:WarpResult) -> Void) -> Request {
        return Alamofire.request(URLString, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers)
            .responseJSON(completionHandler: { completionHandler(WarpTools.toResult($0)) })
    }
    
    open static func post(_ URLString: URLConvertible, parameters: [String : Any]?, headers: [String : String], completionHandler: @escaping (_ warpResult:WarpResult) -> Void) -> Request {
        return Alamofire.request(URLString, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseJSON(completionHandler: { completionHandler(WarpTools.toResult($0)) })
    }
    
    open static func put(_ URLString: URLConvertible, parameters: [String : Any]?, headers: [String : String], completionHandler: @escaping (_ warpResult:WarpResult) -> Void) -> Request {
        return Alamofire.request(URLString, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseJSON(completionHandler: { completionHandler(WarpTools.toResult($0)) })    }
    
    open static func delete(_ URLString: URLConvertible, parameters: [String : Any]?, headers: [String : String], completionHandler: @escaping (_ warpResult:WarpResult) -> Void) -> Request {
        return Alamofire.request(URLString, method: .delete, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseJSON(completionHandler: { completionHandler(WarpTools.toResult($0)) })
    }
    
    
    static func asd() {
//        Alamofire.Manager(configuration: <#T##NSURLSessionConfiguration#>, delegate: <#T##Manager.SessionDelegate#>, serverTrustPolicyManager: <#T##ServerTrustPolicyManager?#>)
//        Alamofire.Manager(session: <#T##NSURLSession#>, delegate: <#T##Manager.SessionDelegate#>, serverTrustPolicyManager: <#T##ServerTrustPolicyManager?#>)
    }
}


