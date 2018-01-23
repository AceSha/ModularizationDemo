//
//  ViewController.swift
//  ModularizationDemo
//
//  Created by 81556205@qq.com on 01/19/2018.
//  Copyright (c) 2018 81556205@qq.com. All rights reserved.
//

import UIKit
import PublicModule
import Modularization

// 更多内容，跳转到 PublicModule

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        Mediator.service(of: ModuleAProtocol.self)
        .register(name: "root", pwd: "12345")

    }
    
    @IBAction func push(_ sender: Any) {
        let vc = Mediator.service(of: ModuleAProtocol.self)
            .mainVC(name: "Main VC")
        navigationController?.pushViewController(vc, animated: true)
    }

}

