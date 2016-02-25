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
    var numberOfChannels = 0
    var toggleAddChannelLabel = false
    var numberOfGroups = 0
    
    var cellContent:[String: [String]] = [
        "basicContent":["Create A Room",
            "Name Of Room",
            "Description Of Room"],
        
        "advancedContent":["Advanced Settings",
            "Room Passcode",
            "Privacy",
            "Embed Channels"]
    ]
    
    var nameOfRoom:String?
    var descriptionOfRoom:String?
    var roomPassCode:String?
    var createChannels = false
    var privateRoom = false
    var toggleAdvancedSettings = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let addNewChannelsNib = UINib(nibName: "AddNewChannelCell", bundle: nil)
        tableView.registerNib(addNewChannelsNib, forCellReuseIdentifier: "AddNewChannelsCell")
        let headerNib = UINib(nibName: "HostReusableCell", bundle: nil)
        tableView.registerNib(headerNib, forCellReuseIdentifier: "Host Reusable Cell")
    }
}


extension ChannelsVC: UITableViewDataSource, UITableViewDelegate {
    
    func configureTableView(){
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 40
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch (indexPath.section, indexPath.row) {
        case (0,0):
            let cell = tableView.dequeueReusableCellWithIdentifier("AddNewChannelsCell") as! AddNewChannelCell
            cell.delegate = self
            if toggleAddChannelLabel == false {
                cell.createButton.hidden = true
                cell.addButton.hidden = false
                return cell
            }
            else {
                cell.addNewChannelLabel.text = "New Channel"
                cell.addButton.hidden = true
                cell.createButton.hidden = false
                return cell
            }
            
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("Host Reusable Cell") as! HostReusableCell
            let newIndex = NSIndexPath(forRow: indexPath.row, inSection: indexPath.section)
            cell.setUpCellAtIndexPath(newIndex, cellContent: cellContent)
            cell.delegate = self
            return cell
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch numberOfChannels {
        case numberOfGroups : return numberOfGroups + 1
        default :
            switch section {
            case 0:
                return cellContent["basicContent"]!.count
            case 1:
                if toggleAdvancedSettings == true {
                    return cellContent["advancedContent"]!.count - 1
                } else {
                    return 1
                }
            case 2:
                return 1
            default:
                return 0
            }
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        switch numberOfChannels {
        case numberOfGroups :
            return numberOfGroups + 1
        default :
            numberOfChannels = numberOfChannels * 2
            return numberOfChannels
                }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let index = NSIndexSet(index: 1)
        switch (indexPath.section, indexPath.row){
        case (1,0):
            toggleAdvancedSettings = !toggleAdvancedSettings
            tableView.scrollEnabled = true
            tableView.reloadSections(index, withRowAnimation: UITableViewRowAnimation.Fade)
        default:break
        }
    }
}


extension ChannelsVC: AddNewChannelCellDelegate {
    func addNewChannel(sender: AnyObject?) {
        numberOfChannels++
        toggleAddChannelLabel = true
        print("add button tapped")
        tableView.reloadData()
    }
    
    func createChannel(sender: AnyObject?) {
        numberOfGroups++
        numberOfChannels = numberOfGroups
        tableView.reloadData()
    }
}

extension ChannelsVC: HostReusableCellDelegate {
    func hostReusableCell(cell: HostReusableCell, valueDidChange: AnyObject?) {
        //add to local variables
    }
    
    func addAnotherChannel(sender: AnyObject?) {
        numberOfChannels = 1
        numberOfGroups++
        print("tapped")
        tableView.reloadData()
    }
}






