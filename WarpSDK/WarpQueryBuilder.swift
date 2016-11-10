//
//  WarpQueryBuilder.swift
//  SwipeRX
//
//  Created by Zonily Jame Pesquera on 27/10/2016.
//
//

public class WarpQueryBuilder {
    public var param:[String : AnyObject] = [:]
    
    public init() {}
    
    public init(_ param:[String : AnyObject]) {
        self.param = param
    }
    
    public func include(values:[String]) -> WarpQueryBuilder {
        self.param["include"] = String(values)
        return self
    }
    
    public func query(values:[WarpQueryConstraint]) -> WarpQueryBuilder {
        var string:String = ""
        for i in 0..<values.count {
            let value = values[i]
            switch value.constraint {
            case .EqualTo, .NotEqualTo, .ContainsString:
                if value.value is String {
                    string = string + "\"\(value.key)\":{\"\(value.constraint.rawValue)\":\"\(value.value as! String)\"}"
                } else {
                    string = string + "\"\(value.key)\":{\"\(value.constraint.rawValue)\":\(value.value)}"
                }
            case .ContainedInArray, .NotContainedInArray:
                string = string + "\"\(value.key)\":{\"\(value.constraint.rawValue)\":\(value.value)}"
            default:
                string = string + "\"\(value.key)\":{\"\(value.constraint.rawValue)\":\(value.value)}"
            }
            
            if values.count > 1 && i != values.count - 1 {
                string = string + ", "
            }
        }
        self.param["where"] = "{\(string)}"
        return self
    }
    
    public func sort(values:[WarpSort]) -> WarpQueryBuilder {
        var string:String = ""
        for i in 0..<values.count {
            let value = values[i]
            string = string + "{\"\(value.key)\": \(value.order.rawValue)}"
            if values.count > 1 && i != values.count - 1 {
                string = string + ", "
            }
        }
        self.param["sort"] = "[\(string)]"
        return self
    }
    
    public func add(key:String, value:AnyObject) -> WarpQueryBuilder {
        self.param[key] = value
        return self
    }
    
    public func limit(value:Int) -> WarpQueryBuilder {
        self.param["limit"] = value
        return self
    }
    
    public func skip(value:Int) -> WarpQueryBuilder {
        self.param["skip"] = value
        return self
    }
    
    public func showDebug() {
        guard param.keys.count > 0 else {
            print("WARPLOG There are no parameters")
            return
        }
        
        print("WARPLOG START =================== \n")
        for key in param.keys {
            switch key {
            case "include":
                print("include: ",String(param["include"] as! String))
            case "where":
                print("where: ",String(param["where"] as! String))
            case "sort":
                print("sort: ",String(param["sort"] as! String))
            case "limit":
                print("limit: ",String(param["limit"] as! Int))
            case "skip":
                print("skip: ",String(param["skip"] as! Int))
            default:
                print(key + ": ",String(param[key]))
            }
        }
        print("\nWARPLOG END ===================")
    }
}

public struct WarpQueryConstraint {
    public var key:String = ""
    public var constraint:WarpConstraint = .EqualTo
    public var value:AnyObject = ""
    
    public init(equalTo value:AnyObject, key:String) {
        self.key = key
        self.constraint = .EqualTo
        self.value = value
    }
    
    public init(notEqualTo value:AnyObject, key:String) {
        self.key = key
        self.constraint = .NotEqualTo
        self.value = value
    }
    
    public init(lessThan value:AnyObject, key:String) {
        self.key = key
        self.constraint = .LessThan
        self.value = value
    }
    
    public init(lessThanOrEqualTo value:AnyObject, key:String) {
        self.key = key
        self.constraint = .LessThanOrEqualTo
        self.value = value
    }
    
    public init(greaterThanOrEqualTo value:AnyObject, key:String) {
        self.key = key
        self.constraint = .GreaterThanOrEqualTo
        self.value = value
    }
    
    public init(greaterThan value:AnyObject, key:String) {
        self.key = key
        self.constraint = .GreaterThan
        self.value = value
    }
    
    public init(existsKey key:String) {
        self.key = key
        self.constraint = .Exists
        self.value = 1
    }
    
    public init(notExistsKey key:String) {
        self.key = key
        self.constraint = .Exists
        self.value = 0
    }
    
    public init(containedIn values:[AnyObject], key:String) {
        self.key = key
        self.constraint = .ContainedInArray
        self.value = values
    }
    
    public init(notContainedIn values:[AnyObject], key:String) {
        self.key = key
        self.constraint = .NotContainedInArray
        self.value = values
    }
    
    public init(startsWith value:String, key:String) {
        self.key = key
        self.constraint = .StartsWithString
        self.value = value
    }
    
    public init(endsWith value:String, key:String) {
        self.key = key
        self.constraint = .EndsWithString
        self.value = value
    }
    
    public init(contains value:String, key:String) {
        self.key = key
        self.constraint = .ContainsString
        self.value = value
    }
    
    public init(contains value:String, keys:[String]) {
        var string:String = ""
        for i in 0..<keys.count {
            let key = keys[i]
            switch i {
            case 0:
                string = key
            case keys.count:
                string = string + key
            default:
                string = string + "|" + key
            }
        }
        self.key = "\(string)"
        self.constraint = .ContainsString
        self.value = value
    }
}

public enum WarpConstraint:String {
    case EqualTo = "eq"
    case NotEqualTo = "neq"
    case GreaterThan = "gt"
    case GreaterThanOrEqualTo = "gte"
    case LessThan = "lt"
    case LessThanOrEqualTo = "lte"
    case Exists = "ex"
    case ContainedInArray = "in"
    case NotContainedInArray = "nin"
    case StartsWithString = "str"
    case EndsWithString = "end"
    case ContainsString = "has"
}

public struct WarpSort {
    var key:String = ""
    var order:WarpOrder = .Ascending
    
    public init(by key:String) {
        self.key = key
        self.order = .Ascending
    }
    
    public init(byDescending key:String) {
        self.key = key
        self.order = .Descending
    }
    
//    init(key:String, order:WarpOrder) {
//        self.key = key
//        self.order = order
//    }
}
