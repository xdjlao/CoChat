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
    var numberOfChannels = 1
    var numberOfSections = 1
    var toggleAddChannelLabel = false
    
    var cellContent:[String: [String]] = [
        "basicContent":["Create A Room",
            "Name Of Room",
            "Description Of Room"],
        
        "advancedContent":["Advanced Settings",
            "Room Passcode",
            "Privacy",
            "Embed Channels"]
    ]
    
    var channelInformation = []
    
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
                if numberOfChannels > 1 {
                    cell.addNewChannelLabel.text = nameOfRoom
                }
            
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
        switch numberOfSections {
            // addchannelCell
        case 1 : return 1
        default :
            switch section {
            case 0:
                return cellContent["basicContent"]!.count // 3
            case 1:
                if toggleAdvancedSettings == true {
                    return cellContent["advancedContent"]!.count - 1 // 4
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
        // first section is addNewChannelCell 
        //second is basicDescription & advanced Settings
        //third is add another Channel
        switch numberOfSections {
        case 1:
            //addChannelCell
            return 1
        default :
            //basic & advanced Cell
            return 2
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
        numberOfSections++
        //Change the top label from add to create
        toggleAddChannelLabel = true
        print("add button tapped")
        tableView.reloadData()
    }
    
    func createChannel(sender: AnyObject?) {
        numberOfChannels++
        numberOfSections = 1
        toggleAddChannelLabel = false
        // add one more channel
//        numberOfSections = numberOfChannels
        // set the sections so that only 2 sections are displayed the compressed newly added channel and the add another channel
        tableView.reloadData()
    }
}

extension ChannelsVC: HostReusableCellDelegate {
    func hostReusableCell(cell: HostReusableCell, valueDidChange: AnyObject?) {
        let addNewCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection:0)) as! AddNewChannelCell
            switch cell.type {
            case .NameOfRoom:
                nameOfRoom = valueDidChange as? String
            case .DescriptionOfRoom:
                descriptionOfRoom = valueDidChange as? String
            case .PasscodeOfRoom:
                roomPassCode = valueDidChange as? String
            case .Privacy:
                if let boolValue = valueDidChange as? Bool {
                    privateRoom = boolValue
                }
                print("switch was tapped inside HostVC")
            default:
                assertionFailure()
            }
        if nameOfRoom != nil && descriptionOfRoom != nil {
            addNewCell.createButton.enabled = true
        }
    }
    
    func addAnotherChannel(sender: AnyObject?) {
        // change this

        print("tapped")
        tableView.reloadData()
    }
}






