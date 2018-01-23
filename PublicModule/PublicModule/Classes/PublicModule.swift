//
//  PublicModule.swift
//  Pods-PulbicModule_Tests
//
//  Created by sy on 2018/1/19.
//

import UIKit
import Modularization
import URLNavigator

public protocol ModuleAProtocol {
    func register(name: String, pwd: String)
    func mainVC(name: String) -> UIViewController
}

public protocol ModuleBProtocol {
    func unregister(name: String)
    func logout(name: String, handler: ((UIAlertAction) -> Swift.Void)?)
}


// 可以自行扩展 单例 Modularization， 使用其他惯用的组件化工具,
// 或其他方式，但请确保拓展的工具的实例是单例
extension Modularization {
    var URLRouter: Navigator {
        return Navigator()
    }
}

public let URLRouter = Modularization.shared.URLRouter

// 对于 Navigator 的 register 和 resolve，建议不要使用硬编码, 当然，下面的解决方案依然不够优雅
// 不过都可以考虑包含在一个公有库内

// 方法1
public struct RegisterURL1 {
    public static let login = "app://login"
}

extension RegisterURL1 {
    public static func user(id: Int?) -> String {
        return id == nil ? "app://user/<int:id>" : "app://user/\(id!)"
    }
}


// 方法2
public enum RegisterURL2 {
    case login
    case user(id: Int)
}

extension RegisterURL2 {
    public var registerURL: String {
        switch self {
        case .login:
            return "app://login"
        case .user:
            return "app://user/<int:id>"
        }
    }

    public var resovleURL: String {
        switch self {
        case .login:
            return "app://login"
        case .user(let id):
            return "app://user/\(id)"
        }
    }
}

// 方法3
public enum RegisterURL3 {
    case login
    case user(id: Int?)
}


extension RegisterURL3 {
    public var plainURL: String {
        switch self {
        case .login:
            return "app://login"
        case .user(let id):
            return id == nil ? "app://user/<int:id>" : "app://user/\(id!)"
        }
    }
}


