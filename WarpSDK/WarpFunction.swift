//
//  WarpFunction.swift
//  Practice
//
//  Created by Zonily Jame Pesquera on 28/10/2016.
//
//

import Foundation

open class WarpFunction {
    fileprivate var functionName: String = ""
    fileprivate init () { }
    
    open static func run(_ functionName: String, parameters: [String: Any]?, completion: @escaping (_ result: AnyObject?, _ error: WarpError?) -> Void) {
        let warp = Warp.sharedInstance
        guard warp != nil else {
            completion(nil, WarpError(code: .serverNotInitialized))
            return
        }
        let _ = WarpAPI.post(warp!.API_ENDPOINT! + "functions/" + functionName, parameters: parameters, headers: warp!.HEADER()) { (warpResult) in
            switch warpResult {
            case .success(let JSON):
                let warpResponse = WarpResponse(json: JSON, result: AnyObject.self)
                switch warpResponse.statusType {
                case .success:
                    completion(warpResponse.result, nil)
                default:
                    completion(nil, WarpError(message: warpResponse.message, status: warpResponse.status))
                }
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}
