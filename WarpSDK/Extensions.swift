//
//  Extensions.swift
//  WarpSDK
//
//  Created by Zonily Jame Pesquera on 08/02/2017.
//  Copyright © 2017 kz. All rights reserved.
//

import UIKit


public extension NSArray {
    func JSONIFY() -> String {
        let data = try! NSJSONSerialization.dataWithJSONObject(self, options: .PrettyPrinted)
        return String(data:data, encoding: NSUTF8StringEncoding)!
    }
}

public extension NSDictionary {
    func JSONIFY() -> String {
        let data = try! NSJSONSerialization.dataWithJSONObject(self, options: .PrettyPrinted)
        return String(data:data, encoding: NSUTF8StringEncoding)!
    }
}
