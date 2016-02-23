//
//  ChannelsVC.swift
//  CoChat
//
//  Created by Aaron B on 2/22/16.
//  Copyright © 2016 Jerry. All rights reserved.
//

import UIKit

class ChannelsVC: UIViewController {
    @IBOutlet var tableView: UITableView!
    var cellContent:Dictionary<String, Array<String>> = [
        "basicContent":["Add A Channel",
            "Name Of Room",
            "Description Of Room"],
        
        "advancedContent":["Advanced Settings",
            "Room Passcode",
            "Embed Channels",
            "Privacy"]
    ]
    
    var nameOfRoom:String?
    var descriptionOfRoom:String?
    var roomPassCode:String?
    var createChannels:Bool?
    var privateRoom:Bool?
    
    var toggleAdvancedSettings = Bool()
    var numberOfChannels = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    
}


extension ChannelsVC: HostReusableCellDelegate {
    func hostReusableCell(cell: HostReusableCell, valueDidChange: AnyObject?) {
        switch cell.type {
        case .NameOfRoom:
            nameOfRoom = valueDidChange as? String
        case .DescriptionOfRoom:
            descriptionOfRoom = valueDidChange as? String
        case .PasscodeOfRoom:
            roomPassCode = valueDidChange as? String
        case .Privacy:
            privateRoom = valueDidChange as? Bool
            print("switch was tapped inside HostVC")
        default:
            assertionFailure()
        }
    }
}

extension ChannelsVC: UITableViewDataSource, UITableViewDelegate {
    func setUpUI(){
        toggleAdvancedSettings = false
        let headerNib = UINib(nibName: "HostReusableCell", bundle: nil)
        tableView.registerNib(headerNib, forCellReuseIdentifier: "Host Reusable Cell")
        tableView.scrollEnabled = false
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Host Reusable Cell") as! HostReusableCell
        cell.setUpCellAtIndexPath(indexPath, cellContent: cellContent)
        cell.delegate = self
        switch (indexPath.section, indexPath.row) {
        case (0,0):
            let contactAddImage = UIImage(named: "contactAdd")
            let addButton = UIButton(type: .Custom)
            let frame = CGRectMake(0, 0, 45, 45)
            addButton.frame = frame
            addButton.setBackgroundImage(contactAddImage, forState: .Normal)
            addButton.backgroundColor = UIColor.clearColor()
            cell.accessoryView = addButton
            cell.userInteractionEnabled = true
            cell.title.userInteractionEnabled = false
        default:break
        }
        return cell
    }
//    
//    func addChannelWasTapped(){
//        numberOfChannels++
////        let sections = tableView.numberOfSections
////        let range = 1 ... sections
////        let index = NSIndexSet(indexesInRange: NSRange(range))
////        tableView.reloadSections(index, withRowAnimation: UITableViewRowAnimation.Fade)
//        
//        UIView.animateWithDuration(1.0, delay: 0.0, options: [], animations: { () -> Void in
//            self.tableView.reloadData()
//            }, completion: nil)
//    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            if numberOfChannels == 0 {
                return 1
            }
            else {
                return cellContent["basicContent"]!.count * numberOfChannels
            }
        case 1:
            if numberOfChannels == 0 {
                return 0}
            if toggleAdvancedSettings == true {
                return cellContent["advancedContent"]!.count
            }
            else {
                return 1
            }
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath)
        let index = NSIndexSet(index: 1)
        switch (indexPath.section, indexPath.row){
        case (0,0):
            numberOfChannels++
            tableView.reloadSections(index, withRowAnimation: UITableViewRowAnimation.Fade)
        case (1,0):
            toggleAdvancedSettings = !toggleAdvancedSettings
            tableView.reloadSections(index, withRowAnimation: UITableViewRowAnimation.Fade)
        case(1,2):
            performSegueWithIdentifier("PushChanelsVC", sender: self)
        default:break
        }
    }
}
