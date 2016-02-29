//
//  ChannelsVC.swift
//  CoChat
//
//  Created by Aaron B on 2/22/16.
//  Copyright © 2016 Jerry. All rights reserved.
//

import UIKit

@objc protocol ChannelsVCDelegate {
    optional func channelsVC(channelsVC: ChannelsVC, didCreateChannel channel: AnyObject)
}

class ChannelsVC: UIViewController {
    weak var delegate: ChannelsVCDelegate?
    var toggleCompressedView = true
    var toggleAdvancedSettings = false
    var room:Room?
    var tempRoom:String?
    var nameOfChannel:String?
    var channelPassCode:String?
    var createChannels = false
    var privateRoom = 0
    
    var channels:[Channel]?
    
    @IBOutlet var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNibsForTableView()
        setUpUI()
        
        if channels == nil {
            channels = [Channel]()
        }
    }
    
    func registerNibsForTableView(){
        let headerNib = UINib(nibName: "HostReusableCell", bundle: nil)
        tableView.registerNib(headerNib, forCellReuseIdentifier: "ChannelInformationCell")
    }
    
    func setUpUI(){
        tableView.separatorStyle = .None
        tableView.backgroundColor = Theme.Colors.ForegroundColor.color
    }
}


extension ChannelsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ChannelInformationCell") as! HostReusableCell
        cell.delegate = self
        cell.createButton.hidden = true
        cell.switchToggle.hidden = true
        cell.addButton.hidden = true
        cell.title.userInteractionEnabled = false

        switch(indexPath.section, indexPath.row){
        case (0 , indexPath.row):
            if channels!.count != 0 {
                //createdChannelsCells
                cell.title.text = channels![indexPath.row].title
                //Add edit functionality
                return cell
            }
            else{
                cell.hidden = true
            }
        case (1,0):
            if toggleCompressedView == true {
                cell.title.text = "Add a Channel"
                cell.addButton.hidden = false
                cell.userInteractionEnabled = true
                return cell
            }
            else {
                cell.title.text = "Create Channel"
                cell.titleConstraintToLeftSuperView.constant = 10
                cell.createButton.hidden = false
                cell.createButton.enabled = true
                cell.selectionStyle = .None
                return cell
            }
        default:
            cell.setUpCellAtIndexPath(indexPath)
        }
        return cell
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
        case 0://header
            return channels!.count
        case 1://create or add room
            return 1
        case 2://basic info
            return 1
        default: //advancedSettingsDecompressed
            if toggleAdvancedSettings == true {
                return 3
            }//advancedSettingsCompressed
            else {
                return 1
            }
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch (indexPath.section, indexPath.row){
        case (1,0):
            toggleCompressedView = false
            tableView.reloadData()
        case (3,0):
            toggleAdvancedSettings = !toggleAdvancedSettings
            tableView.scrollEnabled = true
            let index = NSIndexSet(index: 3)
            tableView.reloadSections(index, withRowAnimation: UITableViewRowAnimation.Fade)
        default:break
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 66
    }
}

extension ChannelsVC: HostReusableCellDelegate {
    func hostReusableCell(cell: HostReusableCell, valueDidChange: AnyObject?) {
//        let addNewCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection:1)) as! ChannelHeaderCell
        switch cell.type {
        case .NameOfRoom:
            nameOfChannel = valueDidChange as? String
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
        default:
            assertionFailure()
        }
        if nameOfChannel != nil {
//            addNewCell.createButton.enabled = true
        }
    }
    
//MARK - FireBase Calls
    func createNewChannel(sender: AnyObject?) {
        toggleCompressedView = true
        guard let name = nameOfChannel else {return}
        if channelPassCode == nil {
            channelPassCode = "123"
        }
        let newChannel = Channel(withTempTitle: name, tempPrivateChannel: privateRoom, tempPassword: channelPassCode!, roomName: "nameOfRoom")
        channels?.append(newChannel)
        delegate?.channelsVC!(self, didCreateChannel: newChannel)
        tableView.reloadData()
    }
    
    func addNewChannel(sender: AnyObject?) {
        toggleCompressedView = false
        tableView.reloadData()
    }
    
    func textFieldDidBeginEditingInCell(textField: UITextField) {
        let textFieldPosition = textField.convertPoint(CGPointZero, toView: self.tableView)
        let indexPath = self.tableView.indexPathForRowAtPoint(textFieldPosition)
        let cell = tableView.cellForRowAtIndexPath(indexPath!)
        textField.alpha = 1.0
        tableView.setContentOffset(CGPointMake(self.tableView.contentOffset.x, self.tableView.contentOffset.y + CGFloat(indexPath!.row) * (cell?.frame.height)! - (navigationController?.navigationBar.frame.height)!), animated: true)
    }
    
    func textFieldDidEndEditingInCell() {
        tableView.setContentOffset(CGPointMake(self.tableView.contentOffset.x, 0.0), animated: true)
    }
}