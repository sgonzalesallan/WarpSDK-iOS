//
//  WarpObject.swift
//  SwipeRX
//
//  Created by Zonily Jame Pesquera on 06/10/2016.
//
//

import EVReflection

public protocol WarpModelProtocol {
    
    /** Set the class' endpoint url */
    static func className() -> String
    
    /** This variable is handled by the WarpSDK */
    static var sharedEndpoint: String? { get set }
    
    func map() -> [String: Any]
    
    static func endPoint() -> String
    
    static func endPoint(_ id: Int) -> String
}

open class WarpModel: EVObject, WarpModelProtocol {
    open var id: Int = 0
    open var createdAt: String = ""
    open var updatedAt: String = ""
    
    open class func className() -> String {
        return ""
    }
    
    public static var sharedEndpoint: String?
    
    convenience public init?(warpJSON: WarpJSON) {
        if let data = try? warpJSON.rawData() {
            self.init(data: data)
        } else {
            return nil
        }
    }
    
    required public init(){
        super.init()
    }
    
    override open func setValue(_ value: Any?, forUndefinedKey key: String) {
        switch key {
        case "created_at":
            self.createdAt = value as! String
        case "updated_at":
            self.updatedAt = value as! String
        default:
            WarpTools.showLog(value, key: key, model: "WarpModel_BaseObject")
        }
    }

    public static func endPoint() -> String {
        guard let endpoint = sharedEndpoint else {
            fatalError("class not yet registered")
        }
        return "\(endpoint)\(className())/"
    }
    
    public class func endPoint(_ id: Int) -> String {
        return "\(endPoint())\(id)"
    }
    
    open func map() -> [String : Any] {
        return ["": ""]
    }
}

public extension Warp {
    public static func registerModels<T>(_ models: [T.Type]) where T: WarpModelProtocol {
        guard let warp = Warp.shared else {
            fatalError("WarpServer is not yet initialized")
        }
        
        models.forEach { (model) in
            model.sharedEndpoint = warp.API_ENDPOINT
        }
    }
}
