//
//  GoalView.swift
//  GoalHub
//
//  Created by 杨钺 on 2018/2/11.
//  Copyright © 2018年 ilime. All rights reserved.
//

import Cocoa

class GoalView: NSView {
    @IBOutlet weak var logo: NSImageView!
    @IBOutlet weak var goalText: NSTextField!
    @IBOutlet weak var nowText: NSTextField!
    
    override func awakeFromNib() {
        logo.image = NSImage(named: NSImage.Name(rawValue: "AppIcon"))
    }
}
