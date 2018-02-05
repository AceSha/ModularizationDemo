//
//  ModuleCoordinator.swift
//  Modularization
//
//  Created by sy on 2018/1/18.
//  Copyright © 2018年 iOSWeekWeekUp. All rights reserved.
//

import Foundation

public protocol MediatorType {
    func register<S, T>(_ service: S.Type, for proto: T.Type) where S: NSObjectProtocol
    func service<T>(of proto: T.Type) -> T
}

public final class _Mediator: MediatorType {

    private var moduleMap: [String : String] = [:]

    private var cachedServiceInstances: [String : Any] = [:]


    /// register service entry for inner-module invoke
    ///
    /// - Parameters:
    ///   - service: service that follow the protocol, meta type
    ///   - proto: protocol, meta type
    public func register<S, T>(_ service: S.Type, for proto: T.Type) where S: NSObjectProtocol {
        let key = String(describing: proto)
        let value = String(reflecting: service)
        moduleMap[key] = value
    }


    /// fetch service instance which follows the protocol
    /// also the instance will be cached
    ///
    /// - Parameter proto: protocol
    /// - Returns: service instance
    public func service<T>(of proto: T.Type) -> T {
        let key = String(describing: proto)

        if let instance = cachedServiceInstances[key] as? T {
            return instance
        }

        guard let value = moduleMap[key]
            else {
                fatalError("not register '\(proto)' yet")
        }

        guard let type = NSClassFromString(value) as? NSObject.Type
            else {
                fatalError("no available class named '\(value)'")
        }

        let instance = type.init() as! T

        cachedServiceInstances[key] = instance

        return instance
    }
}
