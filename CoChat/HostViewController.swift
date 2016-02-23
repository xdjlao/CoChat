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
    var cellContent:Dictionary<String, Array<String>> = [
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
        let cell = tableView.dequeueReusableCellWithIdentifier("Host Reusable Cell") as! HostReusableCell
        cell.setUpCellAtIndexPath(indexPath, cellContent: cellContent)
        cell.cellDelegate = self
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
            performSegueWithIdentifier("PushChannelsVC", sender: self)
        default:break
        }
    }

}
    

