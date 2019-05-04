//
//  ViewController.swift
//  Activity Tracker App
//
//  Created by VijayaBhaskar on 03/05/19.
//  Copyright © 2019 VijayaBhaskar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var activityTableView: UITableView!
    
    var selectedPauseNumber:Int = -1
    
    var selectedIndexpath = IndexPath()
    
    var timer = Timer()
    
    var viewModel = ActivityViewModel()
    
//    var activityTaskArray = [ActivityDataModel]()


    
    override func viewDidLoad() {
        super.viewDidLoad()
//        activityTaskArray = viewModelActivity.activityModelArray
        if let savedPerson = UserDefaults.standard.object(forKey: "SavedActivities") as? Data {
            let decoder = JSONDecoder()
            if let loadedTasks = try? decoder.decode([ActivityDataModel].self, from: savedPerson) {
                viewModel.activityTaskArray = loadedTasks
                SharedModel.shared.activitiesList = viewModel.activityTaskArray
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateActivityTask(notification:)), name: NSNotification.Name(rawValue: "newTasksAdded"), object: nil)
        activityTableView.estimatedRowHeight = 80
        activityTableView.rowHeight = UITableView.automaticDimension
        activityTableView.delegate = self
        activityTableView.dataSource = self
//        activityTableView.setEditing(true, animated: true)

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @objc func updateActivityTask(notification: Notification) {
        if let tasks = notification.object as? [Checklist] {
            viewModel.activityTaskArray[selectedIndexpath.row].tasks = tasks
            SharedModel.shared.activitiesList = viewModel.activityTaskArray
            let cell = activityTableView.cellForRow(at: selectedIndexpath) as! ActivityTvCell
            let checkedCount = viewModel.activityTaskArray[selectedIndexpath.row].tasks!.filter({ $0.status == true }).count
            let totalCount = viewModel.activityTaskArray[selectedIndexpath.row].tasks!.count
            cell.checklistCount.text = "\(checkedCount)/\(totalCount)"
        }
    }
    
    
    @IBAction func addBtnClicked(_ sender: Any) {
        let addActivityVc = self.storyboard?.instantiateViewController(withIdentifier: StoryBoardIds.AddActivityId) as! AddActivityTaskController
//        let backItem = UIBarButtonItem()
//        backItem.title = "Back"
//        self.navigationController!.navigationBar.topItem!.backBarButtonItem = backItem
        self.navigationController?.pushViewController(addActivityVc, animated: true)
        
    }
    

}

extension ViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.activityTaskArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ActivityTvCell = tableView.dequeueReusableCell(withIdentifier: "ActivityTvCell") as! ActivityTvCell
        cell.updateDataModel = viewModel.activityTaskArray[indexPath.row]
        cell.pauseStopBtn.tag = indexPath.row
        cell.pauseStopBtn.addTarget(self, action: #selector(pauseStopBtn), for: .touchUpInside)
       
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(checkListIconClicked))
        cell.checkListView.tag = indexPath.row
        cell.checkListView.addGestureRecognizer(tapGesture)
        cell.checkListView.isUserInteractionEnabled = true
        return cell
    }
    
    func runTimer() {
//        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(updateTimer(id: id))), userInfo: nil, repeats: true)

        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        if var seconds = viewModel.activityTaskArray[selectedPauseNumber].duration {
            seconds += 1
            viewModel.activityTaskArray[selectedPauseNumber].duration = seconds
            SharedModel.shared.activitiesList = viewModel.activityTaskArray
            let indexPath = IndexPath(row: selectedPauseNumber, section: 0)
            
            let cell = activityTableView.cellForRow(at: indexPath) as! ActivityTvCell
            cell.durationLabel.text = viewModel.timeString(time: TimeInterval(seconds))
        }
    }
    
    @objc func checkListIconClicked(gesture:UITapGestureRecognizer){
        let checkListVc = self.storyboard?.instantiateViewController(withIdentifier: StoryBoardIds.CheckListId) as! CheckListsViewController
        checkListVc.selectedId = gesture.view?.tag
        checkListVc.activity = viewModel.activityTaskArray[gesture.view!.tag]
        selectedIndexpath = IndexPath(row: gesture.view!.tag, section: 0)
        self.navigationController?.pushViewController(checkListVc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editOption = UITableViewRowAction(style: .normal, title: "Edit") { action, index in
            print("more button tapped")
            self.gotoEditActivityTask(indexId: indexPath.row)
        }
        editOption.backgroundColor = UIColor.editBgColor
        return [editOption]

    }
    
    func gotoEditActivityTask(indexId:Int){
        let checkListVc = self.storyboard?.instantiateViewController(withIdentifier: StoryBoardIds.EditActivityId) as! EditActivityController
        checkListVc.activity = viewModel.activityTaskArray[indexId]

        self.navigationController?.pushViewController(checkListVc, animated: true)
    }
    
    
    @objc func pauseStopBtn(sender:UIButton){
        let tagNumber = sender.tag
        if selectedPauseNumber != tagNumber {
            updateLastResumedActivity()
        }
        timer.invalidate()
        let indexPath = IndexPath(row: tagNumber, section: 0) // This defines what indexPath is which is used later to define a cell
        let cell = activityTableView.cellForRow(at: indexPath) as! ActivityTvCell // This is where the magic happens - reference to the cell
        selectedPauseNumber = tagNumber
        if viewModel.activityTaskArray[tagNumber].isOn! {
            selectedPauseNumber = -1
            viewModel.activityTaskArray[tagNumber].isOn = false
        }else{
            runTimer()
            viewModel.activityTaskArray[tagNumber].isOn = true
        
        }
        cell.updateDataModel = viewModel.activityTaskArray[tagNumber]
//        activityTableView.reloadData()
    }
    
    func updateLastResumedActivity() {
        if selectedPauseNumber > -1 {
            viewModel.activityTaskArray[selectedPauseNumber].isOn = false
            let indexPath = IndexPath(row: selectedPauseNumber, section: 0)
            let cell = activityTableView.cellForRow(at: indexPath) as! ActivityTvCell
            cell.updateDataModel = viewModel.activityTaskArray[selectedPauseNumber]
        }
    }
}

