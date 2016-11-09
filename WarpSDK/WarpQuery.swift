//
//  WarpQuery.swift
//  Practice
//
//  Created by Zonily Jame Pesquera on 28/10/2016.
//
//

import Foundation

public class WarpQuery {
    private var queryConstraints:[WarpQueryConstraint] = []
    private var queryBuilder:WarpQueryBuilder = WarpQueryBuilder()
    private var className:String = ""
    
    public init(className:String) {
        self.className = className
    }
    
    public func get(objectId:Int, completion:(warpObject:WarpObject?, error:WarpError?) -> Void) {
        let warp = Warp.sharedInstance
        guard warp != nil else {
            completion(warpObject: nil, error: WarpError(code: .ServerNotInitialized))
            return
        }
        WarpAPI.get(warp!.API_ENDPOINT! + "classes/\(className)/\(objectId)", parameters: queryBuilder.query(queryConstraints).param, headers: warp!.HEADER()) { (warpResult) in
            switch warpResult {
            case .Success(let JSON):
                let warpResponse = WarpResponse(JSON: JSON, result: Dictionary<String,AnyObject>.self)
                switch warpResponse.statusType {
                case .Success:
                    completion(warpObject: WarpObject(className: self.className, JSON: warpResponse.result!), error: nil)
                default:
                    completion(warpObject: nil, error: WarpError(message: warpResponse.message, status: warpResponse.status))
                }
                break
            case .Failure(let error):
                completion(warpObject: nil, error: error)
            }
        }
    }
    
    public func find(completion:(warpObjects:[WarpObject]?, error:WarpError?) -> Void) {
        let warp = Warp.sharedInstance
        guard warp != nil else {
            completion(warpObjects: nil, error: WarpError(code: .ServerNotInitialized))
            return
        }
        WarpAPI.get(warp!.API_ENDPOINT! + "classes/\(className)", parameters: queryBuilder.query(queryConstraints).param, headers: warp!.HEADER()) { (warpResult) in
            switch warpResult {
            case .Success(let JSON):
                let warpResponse = WarpResponse(JSON: JSON, result: Array<Dictionary<String,AnyObject>>.self)
                switch warpResponse.statusType {
                case .Success:
                    var warpObjects:[WarpObject] = []
                    for result in warpResponse.result! {
                        warpObjects.append(WarpObject(className: self.className, JSON: result))
                    }
                    completion(warpObjects: warpObjects, error: nil)
                default:
                    completion(warpObjects: nil, error: WarpError(message: warpResponse.message, status: warpResponse.status))
                }
                break
            case .Failure(let error):
                completion(warpObjects: nil, error: error)
            }
        }
    }
    
    public func first(completion:(warpObject:WarpObject?, error:WarpError?) -> Void) {
        limit(1)
        find { (warpObjects, error) in
            completion(warpObject: warpObjects?.first, error: error)
        }
    }
    
    public func limit(value:Int) -> WarpQuery {
        queryBuilder.param["limit"] = value
        return self
    }
    
    public func skip(value:Int) -> WarpQuery {
        queryBuilder.param["skip"] = value
        return self
    }
    
    public func include(values:String...) -> WarpQuery {
        queryBuilder.param["include"] = String(values)
        return self
    }
    
    public func sort(values:WarpSort...) -> WarpQuery {
        var string:String = ""
        for i in 0..<values.count {
            let value = values[i]
            string = string + "{\"\(value.key)\": \(value.order.rawValue)}"
            if values.count > 1 && i != values.count - 1 {
                string = string + ", "
            }
        }
        queryBuilder.param["sort"] = "[\(string)]"
        return self
    }
    
    public func equalTo(value:AnyObject, forKey key:String) -> WarpQuery {
        queryConstraints.append(WarpQueryConstraint(equalTo: value, key: key))
        return self
    }

    public func notEqualTo(value:AnyObject, forKey key:String) -> WarpQuery {
        queryConstraints.append(WarpQueryConstraint(notEqualTo: value, key: key))
        return self
    }
    
    public func lessThan(value:AnyObject, forKey key:String) -> WarpQuery {
        queryConstraints.append(WarpQueryConstraint(lessThan: value, key: key))
        return self
    }
    
    public func lessThanOrEqualTo(value:AnyObject, forKey key:String) -> WarpQuery {
        queryConstraints.append(WarpQueryConstraint(lessThanOrEqualTo: value, key: key))
        return self
    }
    
    public func greaterThanOrEqualTo(value:AnyObject, forKey key:String) -> WarpQuery {
        queryConstraints.append(WarpQueryConstraint(greaterThanOrEqualTo: value, key: key))
        return self
    }
    
    public func greaterThan(value:AnyObject, forKey key:String) -> WarpQuery {
        queryConstraints.append(WarpQueryConstraint(greaterThan: value, key: key))
        return self
    }
    
    public func existsKey(key:String) -> WarpQuery {
        queryConstraints.append(WarpQueryConstraint(existsKey: key))
        return self
    }
    
    public func notExistsKey(key:String) -> WarpQuery {
        queryConstraints.append(WarpQueryConstraint(notExistsKey: key))
        return self
    }
    
    public func containedIn(values:AnyObject..., forKey key:String) -> WarpQuery {
        queryConstraints.append(WarpQueryConstraint(containedIn: values, key: key))
        return self
    }
    
    public func notContainedIn(values:[AnyObject], forKey key:String) -> WarpQuery {
        queryConstraints.append(WarpQueryConstraint(notContainedIn: values, key: key))
        return self
    }
    
    public func startsWith(value:String, forKey key:String) -> WarpQuery {
        queryConstraints.append(WarpQueryConstraint(startsWith: value, key: key))
        return self
    }
    
    public func endsWith(value:String, forKey key:String) -> WarpQuery {
        queryConstraints.append(WarpQueryConstraint(endsWith: value, key: key))
        return self
    }
    
    public func contains(value:String, forKey key:String) -> WarpQuery {
        queryConstraints.append(WarpQueryConstraint(contains: value, key: key))
        return self
    }
    
    public func contains(value:String, keys:String...) -> WarpQuery {
        queryConstraints.append(WarpQueryConstraint(contains: value, keys: keys))
        return self
    }
}
