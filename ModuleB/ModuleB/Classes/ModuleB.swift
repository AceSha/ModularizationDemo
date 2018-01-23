//
//  ModuleB.swift
//  Modularization
//
//  Created by sy on 2018/1/19.
//

import UIKit
import PublicModule
import Modularization

public class ModuleBEntry: AppDelegateEntry {
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]?) -> Bool {

        print("ModuleBEntry application didFinishLaunching")

        Mediator.register(ModuleBService.self, for: ModuleBProtocol.self)

        return true
    }
}

class ModuleBService: NSObject, ModuleBProtocol {
    func unregister(name: String) {
        print("touch MainVC to unregister", name)
    }

    func logout(name: String, handler: ((UIAlertAction) -> Swift.Void)? = nil) {

        let vc = UIAlertController(title: "Log Out", message: nil, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancle", style: .cancel, handler: handler)

        vc.addAction(cancel)

        UIApplication.shared.keyWindow?.rootViewController?.present(vc, animated: true, completion: nil)
    }
}




