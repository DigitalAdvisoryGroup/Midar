//
//  WebServiceHelper.swift
//  XMLRPCDemo
//
//  Created by Kuldip Mac on 25/08/20.
//  Copyright © 2020 Nyusoft. All rights reserved.
//

import Foundation
import SwiftyJSON
import SystemConfiguration
import Alamofire
//import Alamofire
//Check Network Rechability
class Connectivity
{
    class func isConnectedToInternet() ->Bool
    {
        return NetworkReachabilityManager()!.isReachable
    }
}
