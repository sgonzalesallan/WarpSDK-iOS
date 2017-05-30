//
//  WarpErrors.swift
//  Practice
//
//  Created by Zonily Jame Pesquera on 28/10/2016.
//
//

import UIKit
import Foundation

open class WarpError: NSError {
    public init(code: WarpDomainCode) {
        var string: String = ""
        
        switch code {
        case .serverNotInitialized:
            string = "Server was not initialized"
        case .responseValueIsNil:
            string = "Response value is nil"
        case .objectDoesNotExist:
            string = "Object does not exist"
        }
        
        super.init(domain: "WarpError", code: code.rawValue, userInfo: [NSLocalizedDescriptionKey:string])
    }
    
    init(message: String, status: Int) {
        super.init(domain: "WarpError", code: status, userInfo: [NSLocalizedDescriptionKey:message])
    }
    
    init(error:NSError) {
        super.init(domain: error.domain, code: error.code, userInfo: error.userInfo)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public enum WarpDomainCode: Int {
    case serverNotInitialized = 701
    case responseValueIsNil = 702
    case objectDoesNotExist = 703
}
