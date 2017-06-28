//
//  WarpDefault.swift
//  WarpSDK
//
//  Created by Allan Gonzales on 28/06/2017.
//  Copyright © 2017 kz. All rights reserved.
//

import UIKit


open class WarpDefault: NSObject {
    
    open static func saveObject(object: Any, key: String) {
        let defaults = UserDefaults.standard
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: object)
        defaults.set(encodedData, forKey: key)
        defaults.synchronize()
    }
    
    open static func getObject(key: String) -> Any? {
        
        let defaults = UserDefaults.standard
        guard let decoded = defaults.object(forKey: key) as? Data else {
            return nil
        }
        
        guard let unarchived = NSKeyedUnarchiver.unarchiveObject(with: decoded) else {
            return nil
        }
        
        return unarchived
    }
    
    
    open static func remove(key: String) {
        
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: key)
        defaults.synchronize()
        
    }
    
}
