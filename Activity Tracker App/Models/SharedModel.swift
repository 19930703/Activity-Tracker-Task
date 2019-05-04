//
//  SharedModel.swift
//  Activity Tracker App
//
//  Created by VijayaBhaskar on 04/05/19.
//  Copyright © 2019 VijayaBhaskar. All rights reserved.
//

import Foundation

class SharedModel: NSObject {
    
     static let shared = SharedModel()
    
    var activitiesList = [ActivityDataModel]()
}
