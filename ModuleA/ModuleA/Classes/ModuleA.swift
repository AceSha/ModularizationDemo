//
//  ModuleA.swift
//  ModuleA
//
//  Created by sy on 2018/1/19.
//

import UIKit
import PublicModule
import Modularization
import URLNavigator

public class ModuleAEntry: AppDelegateEntry {
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]?) -> Bool {

        print("ModuleAEntry application didFinishLaunching")

        Mediator.register(ModuleAEntry.self, for: ModuleAProtocol.self)
        URLRouter.register(RegisterURL1.user(id: nil)) { _,_,_ -> UIViewController? in
            return UIViewController()
        }

        return true
    }
}


extension ModuleAEntry: ModuleAProtocol {
    public func register(name: String, pwd: String) {
        print("register", name, pwd)
    }

    public func mainVC(name: String) -> UIViewController {
        let vc = MainVC()
        vc.title = name
        vc.view.backgroundColor = .cyan
        vc.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Logout", style: .plain, target: self, action: #selector(logout))
        return vc
    }

    @objc func logout() {
        Mediator.service(of: ModuleBProtocol.self)
            .logout(name: "root") { _ in
                print("did click cancle button")
        }
    }
}

class MainVC: UIViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        Mediator.service(of: ModuleBProtocol.self)
            .unregister(name: "root")
    }
}

