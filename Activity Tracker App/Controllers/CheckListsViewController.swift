//
//  CheckListsViewController.swift
//  Activity Tracker App
//
//  Created by VijayaBhaskar on 04/05/19.
//  Copyright © 2019 VijayaBhaskar. All rights reserved.
//

import UIKit

class CheckListsViewController: UIViewController {

    @IBOutlet weak var checkListTv: UITableView!
    
    var activity: ActivityDataModel!
    
    var selectedId:Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkListTv.delegate = self
        checkListTv.dataSource = self
        checkListTv.estimatedRowHeight = 44.0
        self.navigationController?.navigationBar.shouldRemoveShadow(false)


        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newTasksAdded"), object: activity.tasks)
    }
    

    @objc func checkmarkTapped(recognizer: UITapGestureRecognizer) {
        activity.tasks![recognizer.view!.tag].status = !activity.tasks![recognizer.view!.tag].status
        let cell = checkListTv.cellForRow(at: IndexPath(row: recognizer.view!.tag, section: 0)) as! CheckListTvCell
        if activity.tasks![recognizer.view!.tag].status {
            cell.checkListImageView.image = #imageLiteral(resourceName: "Checked")
        }else {
            cell.checkListImageView.image = #imageLiteral(resourceName: "Unchecked")
        }
    }

}

extension CheckListsViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activity.tasks!.count + 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == activity.tasks!.count {
            let cell:AddCheckListTvCell = tableView.dequeueReusableCell(withIdentifier: "AddCheckListTvCell") as! AddCheckListTvCell
            return cell
        }else{
            let cell:CheckListTvCell = tableView.dequeueReusableCell(withIdentifier: "CheckListTvCell") as! CheckListTvCell
            cell.checkListLabel.text = activity.tasks![indexPath.row].title
            if activity.tasks![indexPath.row].status {
                cell.checkListImageView.image = #imageLiteral(resourceName: "Checked")
            }else {
                cell.checkListImageView.image = #imageLiteral(resourceName: "Unchecked")
            }
            cell.checkListImageView.tag = indexPath.row
            cell.checkListImageView.isUserInteractionEnabled = true
            cell.checkListImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(checkmarkTapped(recognizer:))))
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            if indexPath.row == self.activity.tasks!.count {
                self.addItemClicked()
        }
    }
    }
    
    func addItemClicked(){
        let alertController: UIAlertController = UIAlertController(title: "", message: "Add new item", preferredStyle: .alert)
        
        //cancel button
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            //cancel code
        }
        alertController.addAction(cancelAction)
        
        //Create an optional action
        let nextAction: UIAlertAction = UIAlertAction(title: "Add", style: .default) { action -> Void in
            let text = alertController.textFields!.first!.text
            print("You entered \(text!)")
            self.addToList(str: text!)
            
        }
        alertController.addAction(nextAction)
        
        //Add text field
        alertController.addTextField { (textField) -> Void in
            textField.textAlignment = .center
            textField.placeholder = "Enter Item"
        }
        //Present the AlertController
        present(alertController, animated: true, completion: nil)
    }
    
    func addToList(str:String){
        if !str.isEmpty {
            activity.tasks!.append(Checklist.init(status: false, title: str))
            checkListTv.insertRows(at: [IndexPath(row: activity.tasks!.count - 1, section: 0)], with: .automatic)
        }
    }
    
}
