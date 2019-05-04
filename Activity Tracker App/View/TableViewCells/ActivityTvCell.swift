//
//  ActivityTvCell.swift
//  Activity Tracker App
//
//  Created by VijayaBhaskar on 03/05/19.
//  Copyright © 2019 VijayaBhaskar. All rights reserved.
//

import UIKit

class ActivityTvCell: UITableViewCell {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var duedateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    @IBOutlet weak var pauseStopBtn: UIButton!
    
    @IBOutlet weak var durationLabel: UILabel!
    
    @IBOutlet weak var checkListView: UIView!
    
    @IBOutlet weak var checklistCount: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        mainView.layer.cornerRadius = 5.0
        mainView.layer.masksToBounds = true
        
        userImage.layer.cornerRadius = 5.0
        userImage.layer.masksToBounds = true
 
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var updateDataModel:ActivityDataModel? = nil{
        didSet{
            let viewModel = ActivityViewModel()
            userImage.image = UIImage(named: (updateDataModel?.userImageName)!)
            userImage.contentMode = .scaleAspectFit
            titleLabel.text = updateDataModel?.title
            descLabel.text = updateDataModel?.description
            duedateLabel.text = updateDataModel?.dueDate
            durationLabel.text = viewModel.timeString(time: TimeInterval(updateDataModel!.duration!))
            if updateDataModel!.isOn! {
                pauseStopBtn.setImage(UIImage(named: "Timer_2"), for: .normal)
            }else{
                pauseStopBtn.isSelected = false
                pauseStopBtn.setImage(UIImage(named: "Timer_1"), for: .normal)
            }
            
            let checkedCount = updateDataModel!.tasks!.filter({ $0.status == true }).count
            let totalCount = updateDataModel!.tasks!.count
            checklistCount.text = "\(checkedCount)/\(totalCount)"
        }
    }

}
