//
//  EditActivityController.swift
//  Activity Tracker App
//
//  Created by VijayaBhaskar on 04/05/19.
//  Copyright © 2019 VijayaBhaskar. All rights reserved.
//

import UIKit

class EditActivityController: UIViewController {

    @IBOutlet weak var userImageView: UIImageView!
    
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var activity: ActivityDataModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        userImageView.image = UIImage(named: activity.userImageName!)
        titleLabel.text = activity.title

        userImageView.layer.cornerRadius = userImageView.bounds.height / 2
        userImageView.layer.masksToBounds = true
        self.navigationController?.navigationBar.shouldRemoveShadow(true)

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        let img = UIImage()
//        self.navigationController?.navigationBar.shadowImage = img
//        self.navigationController?.navigationBar.setBackgroundImage(img, for: .default)
        
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
