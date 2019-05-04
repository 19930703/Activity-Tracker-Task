//
//  DataModel.swift
//  Activity Tracker App
//
//  Created by VijayaBhaskar on 04/05/19.
//  Copyright © 2019 VijayaBhaskar. All rights reserved.
//

import Foundation


struct ActivityDataModel: Codable {
    var userImageName:String?
    var title:String?
    var description:String?
    var dueDate:String?
    var duration: Int?
    var tasks: [Checklist]?
    var isOn: Bool?
    
    init(_ image:String,_ titleStr:String,_ desc:String,_ dueDate:String, _ duration: Int, _ tasks: [Checklist], _ isOn: Bool) {
        self.userImageName = image
        self.title = titleStr
        self.description = desc
        self.dueDate = dueDate
        self.duration = duration
        self.tasks = tasks
        self.isOn = isOn
    }

}

struct Checklist: Codable {
    var status: Bool
    var title: String
}
