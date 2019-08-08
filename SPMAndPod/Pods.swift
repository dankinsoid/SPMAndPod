//
//  Pods.swift
//  SPMAndPod
//
//  Created by Ася on 07/08/2019.
//  Copyright © 2019 voidilov. All rights reserved.
//

import Foundation

enum Pods {
    
    static func spec(name: String, homepage: String, git: String, swift: String, ios: String, author: String, email: String) -> String {
        return """
Pod::Spec.new do |s|
s.name             = '\(name)'
s.version          = '0.1.0'
s.summary          = 'A short description of \(name).'

s.description      = <<-DESC
TODO: Add long description of the pod here.
DESC

s.homepage         = '\(homepage)'
# s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { '\(author)' => '\(email)' }
s.source           = { :git => '\(git)', :tag => s.version.to_s }

s.ios.deployment_target = '\(ios)'
s.swift_versions = '\(swift)'
s.source_files = 'Sources/\(name)/**/*'

# s.frameworks = 'UIKit', 'MapKit'
# s.dependency 'AFNetworking', '~> 2.3'
end
"""
    }
    
}
