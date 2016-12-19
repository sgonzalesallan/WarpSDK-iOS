//
//  WarpAPI.swift
//  SwipeRX
//
//  Created by Zonily Jame Pesquera on 06/10/2016.
//
//

import Alamofire
//import EVReflection

public class WarpAPI {
    public static func get(URLString: URLStringConvertible, parameters: [String : AnyObject]?, headers: [String : String], completionHandler: (warpResult:WarpResult) -> Void) -> Request {
        if parameters == nil {
            return Alamofire.request(.GET, URLString, encoding: .URL, headers: headers)
                .responseJSON { (response) in
                    completionHandler(warpResult: WarpTools.toResult(response))
            }
        } else {
            return Alamofire.request(.GET, URLString, parameters: parameters, encoding: .URL, headers: headers)
                .responseJSON { (response) in
                    completionHandler(warpResult: WarpTools.toResult(response))
            }
        }
    }
    
    public static func post(URLString: URLStringConvertible, parameters: [String : AnyObject]?, headers: [String : String], completionHandler: (warpResult:WarpResult) -> Void) -> Request {
        if parameters == nil {
            return Alamofire.request(.POST, URLString, encoding: .JSON, headers: headers)
                .responseJSON { (response) in
                    completionHandler(warpResult: WarpTools.toResult(response))
            }
        } else {
            return Alamofire.request(.POST, URLString, parameters: parameters, encoding: .JSON, headers: headers)
                .responseJSON { (response) in
                    completionHandler(warpResult: WarpTools.toResult(response))
            }
        }
    }
    
    public static func put(URLString: URLStringConvertible, parameters: [String : AnyObject]?, headers: [String : String], completionHandler: (warpResult:WarpResult) -> Void) -> Request {
        if parameters == nil {
            return Alamofire.request(.PUT, URLString, encoding: .JSON, headers: headers)
                .responseJSON { (response) in
                    completionHandler(warpResult: WarpTools.toResult(response))
            }
        } else {
            return Alamofire.request(.PUT, URLString, parameters: parameters, encoding: .JSON, headers: headers)
                .responseJSON { (response) in
                    completionHandler(warpResult: WarpTools.toResult(response))
            }
        }
        
    }
    
    public static func delete(URLString: URLStringConvertible, parameters: [String : AnyObject]?, headers: [String : String], completionHandler: (warpResult:WarpResult) -> Void) -> Request {
        if parameters == nil {
            return Alamofire.request(.DELETE, URLString, encoding: .JSON, headers: headers)
                .responseJSON { (response) in
                    completionHandler(warpResult: WarpTools.toResult(response))
            }
        } else {
            return Alamofire.request(.DELETE, URLString, parameters: parameters, encoding: .JSON, headers: headers)
                .responseJSON { (response) in
                    completionHandler(warpResult: WarpTools.toResult(response))
            }
        }
    }
}


