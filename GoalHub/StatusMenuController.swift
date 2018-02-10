//
//  StatusMenuController.swift
//  GoalHub
//
//  Created by 杨钺 on 2018/2/9.
//  Copyright © 2018年 ilime. All rights reserved.
//

import Cocoa

class StatusMenuController: NSObject {
    @IBOutlet weak var statusMenu: NSMenu!
    @IBOutlet weak var preferences: NSMenuItem!
    @IBOutlet weak var quit: NSMenuItem!
    
    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    var preferencesWindow: PreferencesWindow!
    
    override func awakeFromNib() {
        initStatusMenu()
        initPreferencesWindow()
    }
    
    func initStatusMenu() {
        if let button = statusItem.button {
            button.image = NSImage(named: NSImage.Name(rawValue: "statusMenuIcon"))
            statusItem.menu = statusMenu
        }
    }
    
    func initPreferencesWindow() {
        preferencesWindow = PreferencesWindow()
    }
    
    @IBAction func preferencesClicked(_ sender: NSMenuItem) {
        preferencesWindow.showWindow(sender)
    }
    
    @IBAction func quitClicked(_ sender: NSMenuItem) {
        NSApplication.shared.terminate(sender)
    }
}
