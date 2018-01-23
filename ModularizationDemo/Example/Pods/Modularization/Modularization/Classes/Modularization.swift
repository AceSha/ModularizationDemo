//
//  Modularization.swift
//  Modularization
//
//  Created by sy on 2018/1/18.
//  Copyright © 2018年 iOSWeekWeekUp. All rights reserved.
//

import UIKit

public let Mediator = Modularization.shared.Mediator
public let AllModules = Modularization.shared.moduleLifeCycle

open class AppDelegateEntry: NSObject, ModuleLifeCycleDelegate {
    required public override init() {
        super.init()
    }
}

let mapName = "ModuleMap"

open class Modularization: NSObject {

    @objc public static let shared: Modularization = Modularization()

    let Mediator = _Mediator()

    let moduleLifeCycle = _ModuleLifeCycle()

    private override init() { }

    @objc public func registerEntries() {
        if let filePath = Bundle.main.path(forResource: mapName, ofType: "plist"),
            let array = NSArray(contentsOfFile: filePath) as? [String] {
            moduleLifeCycle.register(array)
        } else {
            fatalError("""
                oops, it seems you don't have the \(mapName).plist file,
                check out whether you have drag this file to your project
                """)

        }
    }
}




