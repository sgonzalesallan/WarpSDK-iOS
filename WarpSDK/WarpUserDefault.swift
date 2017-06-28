//
//  WarpUserDefault.swift
//  WarpSDK
//
//  Created by Allan Gonzales on 28/06/2017.
//  Copyright © 2017 kz. All rights reserved.
//

import UIKit

public class WarpUserDefault: WarpModel {

    public var username: String = ""
    public var email: String = ""
    public var sessionToken: String = ""
    
    static let key: String = "warp_user_key"
    
    public override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    open func save() {
        WarpDefault.saveObject(object: self, key: WarpUserDefault.key)
    }
    
    public static func current() -> WarpUserDefault? {
        if let  user = WarpDefault.getObject(key: WarpUserDefault.key) as? WarpUserDefault {
            return user
        }
        
        return nil
    }
    
    public static func remove(){
        WarpDefault.remove(key: WarpUserDefault.key)
    }
}
