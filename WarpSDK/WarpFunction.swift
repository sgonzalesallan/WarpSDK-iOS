//
//  WarpFunction.swift
//  Practice
//
//  Created by Zonily Jame Pesquera on 28/10/2016.
//
//

import Foundation

class WarpFunction {
    private var functionName:String = ""
    private init () { }
    
    static func run(functionName:String, parameters:[String : AnyObject]?, completion:(result:AnyObject?, error:WarpError?) -> Void) {
        let warp = Warp.sharedInstance
        guard warp != nil else {
            completion(result: nil, error: WarpError(code: .ServerNotInitialized))
            return
        }
        WarpAPI.post(warp!.API_ENDPOINT! + "functions/" + functionName, parameters: parameters, headers: warp!.HEADER()) { (warpResult) in
            switch warpResult {
            case .Success(let JSON):
                let warpResponse = WarpResponse(JSON: JSON, result: AnyObject.self)
                switch warpResponse.statusType {
                case .Success:
                    completion(result: warpResponse.result, error: nil)
                default:
                    completion(result: nil, error: WarpError(message: warpResponse.message, status: warpResponse.status))
                }
            case .Failure(let error):
                completion(result: nil, error: error)
            }
        }
    }
}
