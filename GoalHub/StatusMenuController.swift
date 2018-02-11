//
//  StatusMenuController.swift
//  GoalHub
//
//  Created by 杨钺 on 2018/2/9.
//  Copyright © 2018年 ilime. All rights reserved.
//

import Cocoa

class StatusMenuController: NSObject, PreferencesWindowDelegate {
    @IBOutlet weak var statusMenu: NSMenu!
    @IBOutlet weak var preferences: NSMenuItem!
    @IBOutlet weak var quit: NSMenuItem!
    
    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    var preferencesWindow: PreferencesWindow!
    var githubClient: GithubClient!
    
    override func awakeFromNib() {
        initStatusMenu()
        initPreferencesWindow()
        
        githubClient = GithubClient()
        githubClient.fetchProfile()
    }
    
    func preferencesDidUpdate() {
        githubClient.updateUserAndToken()
        githubClient.fetchProfile()
    }
    
    func initStatusMenu() {
        if let button = statusItem.button {
            button.image = NSImage(named: NSImage.Name(rawValue: "statusMenuIcon"))
            statusItem.menu = statusMenu
        }
    }
    
    func initPreferencesWindow() {
        preferencesWindow = PreferencesWindow()
        preferencesWindow.delegate = self
    }
    
    @IBAction func preferencesClicked(_ sender: NSMenuItem) {
        preferencesWindow.showWindow(sender)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    @IBAction func quitClicked(_ sender: NSMenuItem) {
        NSApplication.shared.terminate(sender)
    }
}
