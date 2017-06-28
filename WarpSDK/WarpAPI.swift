//
//  WarpAPI.swift
//  SwipeRX
//
//  Created by Zonily Jame Pesquera on 06/10/2016.
//
//

import Alamofire

open class WarpAPI {
    var shared: WarpAPI = WarpAPI()
}

public extension WarpAPI {
    
    public static func get(_ URLString: URLConvertible, parameters: [String : Any]?, headers: [String : String]) -> WarpDataRequest {
        return self.service(.get, URLString: URLString, parameters: parameters)
    }
    
    public static func post(_ URLString: URLConvertible, parameters: [String : Any]?, headers: [String : String]) -> WarpDataRequest {
        return self.service(.post, URLString: URLString, parameters: parameters)
    }
    
    public static func put(_ URLString: URLConvertible, parameters: [String : Any]?, headers: [String : String]) -> WarpDataRequest {
        return self.service(.put, URLString: URLString, parameters: parameters)
    }
    
    public static func delete(_ URLString: URLConvertible, parameters: [String : Any]?, headers: [String : String]) -> WarpDataRequest {
        return self.service(.delete, URLString: URLString, parameters: parameters)
    }
    
    public static func service(_ method: HTTPMethod, URLString: URLConvertible, parameters: [String : Any]?) -> WarpDataRequest {
        guard let _ = Warp.shared else {
            fatalError("WarpServer is not yet initialized")
        }

        return Alamofire.request(URLString, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: Warp.HEADERS)
    }
}

public extension WarpDataRequest {
    func warpResponse(_ block: @escaping (_ warpResult: WarpResult) -> Void) -> WarpDataRequest {
        return responseJSON(completionHandler: { block(WarpTools.toResult($0)) })
    }
}
