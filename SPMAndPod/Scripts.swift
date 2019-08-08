//
//  Scripts.swift
//  SPMAndPod
//
//  Created by Ася on 07/08/2019.
//  Copyright © 2019 voidilov. All rights reserved.
//

import Foundation

final class Script {
    
   private(set) var isRunning = false
    let buildTask = Process()
    let taskQueue = DispatchQueue.global(qos: DispatchQoS.QoSClass.background)
    let targetName: String
    let projectURL: URL
    let repositoryURL: URL
    
    init(targetName: String, projectURL: URL, repositoryURL: URL) {
        self.targetName = targetName
        self.projectURL = projectURL.appendingPathComponent(targetName, isDirectory: true)
        self.repositoryURL = repositoryURL
    }
    
    func stopTask() {
        guard isRunning else { return }
        buildTask.terminate()
    }
    
    func run(_ completion: @escaping (Result<Void, Error>) -> ()) {
        do {
            try FileManager.default.createDirectory(at: projectURL, withIntermediateDirectories: true, attributes: nil)
            var homepage = repositoryURL.absoluteString
            if homepage.hasSuffix(".git") {
                homepage.removeLast(4)
            }
            let podspec = Pods.spec(name: targetName, homepage: homepage, git: repositoryURL.absoluteString, swift: "5.0", ios: "10.0", author: "Author", email: "example@gmail.com")
            FileManager.default.createFile(atPath: projectURL.appendingPathComponent(targetName + ".podspec").path, contents: Data(podspec.utf8), attributes: nil)
            try FileManager.default.createFile(atPath: projectURL.appendingPathComponent("LICENSE").path, contents: Data(contentsOf: Bundle.main.url(forResource: "LICENSE", withExtension: nil)!), attributes: nil)
            runScript(completion)
        } catch {
            completion(.failure(Errors.unknown))
        }
    }
    
    private func runScript(_ completion: @escaping (Result<Void, Error>) -> ()) {
        isRunning = true
        taskQueue.async {
            guard let path = Bundle.main.path(forResource: "BuildScript", ofType: "command") else {
                print("Unable to locate BuildScript.command")
                return
            }
            self.buildTask.launchPath = path
            self.buildTask.arguments = [self.targetName, self.projectURL.path, self.repositoryURL.absoluteString]
            self.buildTask.terminationHandler = { _ in
                self.isRunning = false
            }
            self.captureStandardOutputAndRouteToTextView(self.buildTask)
            self.buildTask.launch()
            self.buildTask.waitUntilExit()
            let status = self.buildTask.terminationStatus
            if status == 0 {
                completion(.success(()))
            } else {
                completion(.failure(Errors.unknown))
            }
        }
        
    }
    
    func captureStandardOutputAndRouteToTextView(_ task: Process) {
        let outputPipe = Pipe()
        task.standardOutput = outputPipe
        outputPipe.fileHandleForReading.waitForDataInBackgroundAndNotify()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.NSFileHandleDataAvailable, object: outputPipe.fileHandleForReading, queue: nil) {
            notification in
            
            let output = outputPipe.fileHandleForReading.availableData
            let outputString = String(data: output, encoding: String.Encoding.utf8) ?? ""
            print(outputString)
            outputPipe.fileHandleForReading.waitForDataInBackgroundAndNotify()
        }
    }
    
    enum Errors: Error {
        case unknown
    }
    
}
