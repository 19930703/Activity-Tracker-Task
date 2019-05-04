//
//  ActivityViewModel.swift
//  Activity Tracker App
//
//  Created by VijayaBhaskar on 04/05/19.
//  Copyright © 2019 VijayaBhaskar. All rights reserved.
//

import UIKit

class ActivityViewModel: NSObject {
    var imagesArra = ["Logo_1","Logo_2","Logo_3"]
    var titlesArra = ["Update Changes in homepage","Splash Screen Design","Icon Creation"]
    var descArra = ["Website","iOS","Web App"]
    var activityTaskArray = [ActivityDataModel]()
    

    override init() {
        super.init()
        activityTaskArray.removeAll()
        let dateStr = self.getDueDate()
        for index in 0...imagesArra.count - 1 {
            activityTaskArray.append(ActivityDataModel(imagesArra[index], titlesArra[index], descArra[index], dateStr, 0, [Checklist](), false))
        }

    }
    
    func getDueDate()->String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let startDate = Date()
        let endDate = Date(timeInterval: 2*86400, since: startDate)
        let myString = formatter.string(from: endDate) // string purpose I add here
        let yourDate = formatter.date(from: myString)

        formatter.dateFormat = "EEE, dd MMM yyyy"
        let myStringafd = formatter.string(from: yourDate!)

        return myStringafd

    }
    
    
    func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }

}
