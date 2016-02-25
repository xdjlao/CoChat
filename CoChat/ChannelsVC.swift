//
//  ChannelsVC.swift
//  CoChat
//
//  Created by Aaron B on 2/22/16.
//  Copyright © 2016 Jerry. All rights reserved.
//

import UIKit

class ChannelsVC: UIViewController {
    var toggleCompressedView = true
    var toggleAdvancedSettings = false
    var room:String?
    var channelContent:[String: [String]] = [
        "basicContent":["Create A Room",
            "Name Of Room",
            "Description Of Room"],
        
        "advancedContent":["Advanced Settings",
            "Room Passcode",
            "Privacy",
            "Embed Channels"]
    ]
    
    var nameOfChannel:String?
    var descriptionOfChannel:String?
    var channelPassCode:String?
    var createChannels = false
    var privateRoom = 0
    
    var channels = [Channel]()
    
    @IBOutlet var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNibsForTableView()
    
    }
    
    func registerNibsForTableView(){
        let addNewChannelsNib = UINib(nibName: "ChannelHeaderCell", bundle: nil)
        tableView.registerNib(addNewChannelsNib, forCellReuseIdentifier: "ChannelHeaderCell")
        let headerNib = UINib(nibName: "HostReusableCell", bundle: nil)
        tableView.registerNib(headerNib, forCellReuseIdentifier: "ChannelInformationCell")
    }

}


extension ChannelsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let informationCell = tableView.dequeueReusableCellWithIdentifier("ChannelInformationCell") as! HostReusableCell
        let headerCell = tableView.dequeueReusableCellWithIdentifier("ChannelHeaderCell") as! ChannelHeaderCell
        
        headerCell.delegate = self
        informationCell.delegate = self
        
        let basicContent =  channelContent["basicContent"]
        let advancedContent = channelContent["advancedContent"]
        
        
        informationCell.icon.image = nil
        informationCell.userInteractionEnabled = true
        informationCell.switchToggle.hidden = true
        informationCell.selectionStyle = .None
        informationCell.accessoryType = UITableViewCellAccessoryType.None
        informationCell.title.userInteractionEnabled = true
        
        
        switch(indexPath.section, indexPath.row){
            
        case (0 , indexPath.row):
            if channels.count != 0 {
                //createdChannelsCells
                headerCell.headerTitle.text = channels[indexPath.row].title
                headerCell.addButton.hidden = true
                headerCell.createButton.hidden = true
                //Add edit functionality
                return headerCell
            }
            else{
                headerCell.hidden = true
            }
        case (1,0):
            if toggleCompressedView == true {
                headerCell.headerTitle.text = "Add a Channel"
                headerCell.addButton.hidden = false
                headerCell.createButton.hidden = true
                headerCell.addButton.enabled = true
                return headerCell}
            else {
                headerCell.headerTitle.text = "Create Channel"
                headerCell.addButton.hidden = true
                headerCell.createButton.hidden = false
                return headerCell}
        case (2,0):
            //Basic Info Header
            informationCell.icon.image = UIImage(named: "Create")
            informationCell.title.text = basicContent![indexPath.row]
            informationCell.userInteractionEnabled = false
            return informationCell
        case (2,1):
            informationCell.title.text = basicContent![indexPath.row]
            informationCell.type = .NameOfRoom
            return informationCell
        case (2,2):
            informationCell.title.text = basicContent![indexPath.row]
            informationCell.type = .DescriptionOfRoom
            return informationCell
        case (3,0):
            informationCell.icon.image = UIImage(named: "Settings")
            informationCell.title.text = advancedContent![indexPath.row]
            informationCell.title.userInteractionEnabled = false
            informationCell.selectionStyle = .Gray
            return informationCell
        case (3,1):
            informationCell.title.text = advancedContent![indexPath.row]
            informationCell.type = .PasscodeOfRoom
            return informationCell
        case (3,2):
            informationCell.title.text = advancedContent![indexPath.row]
            informationCell.title.userInteractionEnabled = false
            informationCell.type = .Privacy
            informationCell.switchToggle.hidden = false
            return informationCell
        case (3,3):
            informationCell.title.text = advancedContent![indexPath.row]
            informationCell.title.userInteractionEnabled = false
            informationCell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            informationCell.selectionStyle = .Gray
            return informationCell
        default:
            assertionFailure()
        }
        return headerCell
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if toggleCompressedView == true {
            // show created channels || no header and the addRoom cell
            return 2
        }
        else {
            // non compressed view showing the created channels || no header & the create room & the basic info
            return 4
        }
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0:
            //header
            return 1
        case 1:
            //create or add room
            return 1
        case 2:
            //basic info
            return 3
        default:
            if toggleAdvancedSettings == true {
                //advancedSettingsDecompressed
                return 3
            }
                //advancedSettingsCompressed
            else {
                return 1
            }
        }
    }
}

extension ChannelsVC: ChannelHeaderCellDelegate {
    func addNewChannel(sender: AnyObject?) {
        toggleCompressedView = false
        //Change the top label from add to create
        print("add button tapped")
        tableView.reloadData()
    }
    
    func createChannel(sender: AnyObject?) {
        toggleCompressedView = true
        guard let name = nameOfChannel, subTitle = descriptionOfChannel else {return}
        if channelPassCode == nil {
            channelPassCode = "123"
        }
        let newChannel = Channel(withTempTitle: name, tempSubtitle: subTitle, tempPrivateChannel: privateRoom, tempPassword: channelPassCode!, roomName: room!)
        channels.append(newChannel)
        // add one more channel
        // set the sections so that only 2 sections are displayed the compressed newly added channel and the add another channel
        tableView.reloadData()
    }
}

extension ChannelsVC: HostReusableCellDelegate {
    func hostReusableCell(cell: HostReusableCell, valueDidChange: AnyObject?) {
        let addNewCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection:1)) as! ChannelHeaderCell
        switch cell.type {
        case .NameOfRoom:
            nameOfChannel = valueDidChange as? String
        case .DescriptionOfRoom:
            descriptionOfChannel = valueDidChange as? String
        case .PasscodeOfRoom:
            channelPassCode = valueDidChange as? String
        case .Privacy:
            if let boolValue = valueDidChange as? Bool {
                if boolValue == true {
                    privateRoom = 1
                }
                else {
                    privateRoom = 0
                }
            }
            print("switch was tapped inside HostVC")
        default:
            assertionFailure()
        }
        if nameOfChannel != nil && descriptionOfChannel != nil {
            addNewCell.createButton.enabled = true
        }
    }
    
    func addAnotherChannel(sender: AnyObject?) {
        // change this
        print("tapped")
        tableView.reloadData()
    }
}


