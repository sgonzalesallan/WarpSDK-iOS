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
        let data = try! JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
        return String(data:data, encoding: String.Encoding.utf8)!
    }
}

public extension NSDictionary {
    func JSONIFY() -> String {
        let data = try! JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
        return String(data:data, encoding: String.Encoding.utf8)!
    }
}
