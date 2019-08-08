//
//  ViewController.swift
//  SPMAndPod
//
//  Created by Ася on 07/08/2019.
//  Copyright © 2019 voidilov. All rights reserved.
//

import Cocoa

class TasksViewController: NSViewController {
    
    //Controller Outlets
    @IBOutlet var outputText: NSTextView!
    @IBOutlet var spinner: NSProgressIndicator!
    @IBOutlet var projectPath: NSPathControl!
    @IBOutlet var buildButton: NSButton!
    @IBOutlet var targetName: NSTextField!
    @IBOutlet var repoURLField: NSTextField!
    
    var buildTask: Script!
    
    @IBAction func startTask(_ sender: AnyObject) {
        
        //1.
        outputText.string = ""
        
        if let projectURL = projectPath.url, let repo = URL(string: repoURLField.stringValue) {
            buildTask = Script(targetName: targetName.stringValue, projectURL: projectURL, repositoryURL: repo)
            buildTask.run { result in
                print(result)
            }
        }
        
    }
    
    @IBAction func stopTask(_ sender:AnyObject) {
        buildTask?.stopTask()
    }
    
}
