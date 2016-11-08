//
//  WarpErrors.swift
//  Practice
//
//  Created by Zonily Jame Pesquera on 28/10/2016.
//
//

import UIKit
import Foundation

class WarpError:NSError {
    init(code:WarpDomainCode) {
        var string:String = ""
        
        switch code {
        case .ServerNotInitialized:
            string = "Server was not initialized"
        case .ResponseValueIsNil:
            string = "Response value is nil"
        case .ObjectDoesNotExist:
            string = "Object does not exist"
        }
        super.init(domain: "WarpError", code: code.rawValue, userInfo: [NSLocalizedDescriptionKey:string])
    }
    
    init(message:String, status:Int) {
        super.init(domain: "WarpError", code: status, userInfo: [NSLocalizedDescriptionKey:message])
    }
    
    init(error:NSError) {
        super.init(domain: error.domain, code: error.code, userInfo: error.userInfo)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

enum WarpDomainCode:Int {
    case ServerNotInitialized = 701
    case ResponseValueIsNil = 702
    case ObjectDoesNotExist = 703
}
