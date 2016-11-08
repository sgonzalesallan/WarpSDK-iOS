//
//  WarpAPI.swift
//  SwipeRX
//
//  Created by Zonily Jame Pesquera on 06/10/2016.
//
//

import Alamofire
//import EVReflection

class WarpAPI {
    static func get(URLString: URLStringConvertible, parameters: [String : AnyObject]?, headers: [String : String], completionHandler: (warpResult:WarpResult) -> Void){
        if parameters == nil {
            Alamofire.request(.GET, URLString, encoding: .URL, headers: headers)
                .responseJSON { (response) in
                    completionHandler(warpResult: WarpTools.toResult(response))
            }
        } else {
            Alamofire.request(.GET, URLString, parameters: parameters, encoding: .URL, headers: headers)
                .responseJSON { (response) in
                    completionHandler(warpResult: WarpTools.toResult(response))
            }
        }
    }
    
    static func post(URLString: URLStringConvertible, parameters: [String : AnyObject]?, headers: [String : String], completionHandler: (warpResult:WarpResult) -> Void){
        if parameters == nil {
            Alamofire.request(.POST, URLString, encoding: .JSON, headers: headers)
                .responseJSON { (response) in
                    completionHandler(warpResult: WarpTools.toResult(response))
            }
        } else {
            Alamofire.request(.POST, URLString, parameters: parameters, encoding: .JSON, headers: headers)
                .responseJSON { (response) in
                    completionHandler(warpResult: WarpTools.toResult(response))
            }
        }
    }
    
    static func put(URLString: URLStringConvertible, parameters: [String : AnyObject]?, headers: [String : String], completionHandler: (warpResult:WarpResult) -> Void){
        if parameters == nil {
            Alamofire.request(.PUT, URLString, encoding: .JSON, headers: headers)
                .responseJSON { (response) in
                    completionHandler(warpResult: WarpTools.toResult(response))
            }
        } else {
            Alamofire.request(.PUT, URLString, parameters: parameters, encoding: .JSON, headers: headers)
                .responseJSON { (response) in
                    completionHandler(warpResult: WarpTools.toResult(response))
            }
        }
        
    }
    
    static func delete(URLString: URLStringConvertible, parameters: [String : AnyObject]?, headers: [String : String], completionHandler: (warpResult:WarpResult) -> Void){
        if parameters == nil {
            Alamofire.request(.DELETE, URLString, encoding: .JSON, headers: headers)
                .responseJSON { (response) in
                    completionHandler(warpResult: WarpTools.toResult(response))
            }
        } else {
            Alamofire.request(.DELETE, URLString, parameters: parameters, encoding: .JSON, headers: headers)
                .responseJSON { (response) in
                    completionHandler(warpResult: WarpTools.toResult(response))
            }
        }
    }
}


