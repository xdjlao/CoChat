//
//  HostViewController.swift
//  CoChat
//
//  Created by Aaron B on 2/20/16.
//  Copyright © 2016 Jerry. All rights reserved.
//

import UIKit

class HostViewController: UIViewController {
    @IBOutlet var overlayView: UIView!
    @IBOutlet var tableView: UITableView!
    var cellContent = [
        "basicContent":["Create A Room",
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    func setUpUI(){
        toggleAdvancedSettings = false
        let headerNib = UINib(nibName: "HostReusableCell", bundle: nil)
        tableView.registerNib(headerNib, forCellReuseIdentifier: "Host Reusable Cell")
        tableView.scrollEnabled = false
    }
}

extension HostViewController: HostReusableCellDelegate {
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

extension HostViewController: UITableViewDelegate, UITableViewDataSource {    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let basicContent:Array = cellContent["basicContent"]!
        let advancedContent:Array = cellContent["advancedContent"]!
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Host Reusable Cell") as! HostReusableCell
        cell.icon.image = nil
        cell.userInteractionEnabled = true
        cell.switchToggle.hidden = true
        cell.selectionStyle = .None
        cell.accessoryType = UITableViewCellAccessoryType.None
        cell.title.userInteractionEnabled = true
        
        switch (indexPath.section, indexPath.row) {
        case (0,0):
            cell.icon.image = UIImage(named: "Create")
            cell.title.text = basicContent[indexPath.row]
            cell.userInteractionEnabled = false
        case (1,0):
            cell.icon.image = UIImage(named: "Settings")
            cell.title.text = advancedContent[indexPath.row]
            cell.title.userInteractionEnabled = false
            cell.selectionStyle = .Gray
        case (0,1):
            cell.title.text = basicContent[indexPath.row]
            cell.cellDelegate = self
            cell.type = .NameOfRoom
        case (0,2):
            cell.title.text = basicContent[indexPath.row]
            cell.cellDelegate = self
            cell.type = .DescriptionOfRoom
        case (1,1):
            cell.title.text = advancedContent[indexPath.row]
            cell.cellDelegate = self
            cell.type = .PasscodeOfRoom
        case (1,2):
            cell.title.text = advancedContent[indexPath.row]
            cell.title.userInteractionEnabled = false
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            cell.selectionStyle = .Gray
        case (1,3):
            cell.title.text = advancedContent[indexPath.row]
            cell.title.userInteractionEnabled = false
            cell.type = .Privacy
            cell.switchToggle.hidden = false
            cell.cellDelegate = self
        default:
            assertionFailure()
        }
        return cell
    }

    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return cellContent["basicContent"]!.count
        case 1:
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
        case (1,0):
            toggleAdvancedSettings = !toggleAdvancedSettings
            tableView.reloadSections(index, withRowAnimation: UITableViewRowAnimation.Fade)
        case(1,2):
            performSegueWithIdentifier("PushChanelsVC", sender: self)
        default:break
        }
    }

}
    

