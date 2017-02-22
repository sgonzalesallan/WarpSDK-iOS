//
//  WarpQuery.swift
//  Practice
//
//  Created by Zonily Jame Pesquera on 28/10/2016.
//
//

import Foundation

open class WarpQuery {
    fileprivate var queryConstraints:[WarpQueryConstraint] = []
    fileprivate var queryBuilder:WarpQueryBuilder = WarpQueryBuilder()
    fileprivate var className: String = ""
    
    public init(className: String) {
        self.className = className
    }
    
    open func get(_ objectId: Int, completion:@escaping (_ warpObject:WarpObject?, _ error: WarpError?) -> Void) {
        let warp = Warp.sharedInstance
        guard warp != nil else {
            completion(nil, WarpError(code: .serverNotInitialized))
            return
        }
        let _ = WarpAPI.get(warp!.API_ENDPOINT! + "classes/\(className)/\(objectId)", parameters: queryBuilder.query(queryConstraints).param, headers: warp!.HEADER()) { (warpResult) in
            switch warpResult {
            case .success(let JSON):
                let warpResponse = WarpResponse(JSON: JSON as AnyObject, result: Dictionary<String,AnyObject>.self)
                switch warpResponse.statusType {
                case .success:
                    completion(WarpObject(className: self.className, JSON: warpResponse.result!), nil)
                default:
                    completion(nil, WarpError(message: warpResponse.message, status: warpResponse.status))
                }
                break
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    open func find(_ completion:@escaping (_ warpObjects:[WarpObject]?, _ error: WarpError?) -> Void) {
        let warp = Warp.sharedInstance
        guard warp != nil else {
            completion(nil, WarpError(code: .serverNotInitialized))
            return
        }
        let _ = WarpAPI.get(warp!.API_ENDPOINT! + "classes/\(className)", parameters: queryBuilder.query(queryConstraints).param, headers: warp!.HEADER()) { (warpResult) in
            switch warpResult {
            case .success(let JSON):
                let warpResponse = WarpResponse(JSON: JSON as AnyObject, result: Array<Dictionary<String,AnyObject>>.self)
                switch warpResponse.statusType {
                case .success:
                    var warpObjects:[WarpObject] = []
                    for result in warpResponse.result! {
                        warpObjects.append(WarpObject(className: self.className, JSON: result))
                    }
                    completion(warpObjects, nil)
                default:
                    completion(nil, WarpError(message: warpResponse.message, status: warpResponse.status))
                }
                break
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    open func first(_ completion:@escaping (_ warpObject:WarpObject?, _ error: WarpError?) -> Void) {
        let _ = limit(1).find { (warpObjects, error) in
            completion(warpObjects?.first, error)
        }
    }
    
    open func limit(_ value: Int) -> WarpQuery {
        queryBuilder.param["limit"] = value as AnyObject?
        return self
    }
    
    open func skip(_ value: Int) -> WarpQuery {
        queryBuilder.param["skip"] = value as AnyObject?
        return self
    }
    
    open func include(_ values: String...) -> WarpQuery {
        queryBuilder.param["include"] = String(describing: values) as AnyObject?
        return self
    }
    
    open func sort(_ values:WarpSort...) -> WarpQuery {
        var string: String = ""
        for i in 0..<values.count {
            let value = values[i]
            string = string + "{\"\(value.key)\": \(value.order.rawValue)}"
            if values.count > 1 && i != values.count - 1 {
                string = string + ", "
            }
        }
        queryBuilder.param["sort"] = "[\(string)]" as AnyObject?
        return self
    }
    
    open func equalTo(_ value: AnyObject, forKey key: String) -> WarpQuery {
        queryConstraints.append(WarpQueryConstraint(equalTo: value, key: key))
        return self
    }

    open func notEqualTo(_ value: AnyObject, forKey key: String) -> WarpQuery {
        queryConstraints.append(WarpQueryConstraint(notEqualTo: value, key: key))
        return self
    }
    
    open func lessThan(_ value: AnyObject, forKey key: String) -> WarpQuery {
        queryConstraints.append(WarpQueryConstraint(lessThan: value, key: key))
        return self
    }
    
    open func lessThanOrEqualTo(_ value: AnyObject, forKey key: String) -> WarpQuery {
        queryConstraints.append(WarpQueryConstraint(lessThanOrEqualTo: value, key: key))
        return self
    }
    
    open func greaterThanOrEqualTo(_ value: AnyObject, forKey key: String) -> WarpQuery {
        queryConstraints.append(WarpQueryConstraint(greaterThanOrEqualTo: value, key: key))
        return self
    }
    
    open func greaterThan(_ value: AnyObject, forKey key: String) -> WarpQuery {
        queryConstraints.append(WarpQueryConstraint(greaterThan: value, key: key))
        return self
    }
    
    open func existsKey(_ key: String) -> WarpQuery {
        queryConstraints.append(WarpQueryConstraint(existsKey: key))
        return self
    }
    
    open func notExistsKey(_ key: String) -> WarpQuery {
        queryConstraints.append(WarpQueryConstraint(notExistsKey: key))
        return self
    }
    
    open func containedIn(_ values: AnyObject..., forKey key: String) -> WarpQuery {
        queryConstraints.append(WarpQueryConstraint(containedIn: values, key: key))
        return self
    }
    
    open func notContainedIn(_ values:[AnyObject], forKey key: String) -> WarpQuery {
        queryConstraints.append(WarpQueryConstraint(notContainedIn: values, key: key))
        return self
    }
    
    open func startsWith(_ value: String, forKey key: String) -> WarpQuery {
        queryConstraints.append(WarpQueryConstraint(startsWith: value, key: key))
        return self
    }
    
    open func endsWith(_ value: String, forKey key: String) -> WarpQuery {
        queryConstraints.append(WarpQueryConstraint(endsWith: value, key: key))
        return self
    }
    
    open func contains(_ value: String, forKey key: String) -> WarpQuery {
        queryConstraints.append(WarpQueryConstraint(contains: value, key: key))
        return self
    }
    
    open func contains(_ value: String, keys: String...) -> WarpQuery {
        queryConstraints.append(WarpQueryConstraint(contains: value, keys: keys))
        return self
    }
}
