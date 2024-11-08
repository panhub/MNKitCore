//
//  MNProtocol.swift
//  MNKit-Core
//
//  Created by pan on 2022/8/1.
//  核心协议

import UIKit
import Foundation
import ObjectiveC.runtime

// MARK: - Nib Load
public protocol MNNibWrapper {}
extension MNNibWrapper {
    
    /// 从xib加载类
    /// - Parameters:
    ///   - bundle: 资源束实例
    ///   - nibName: nib文件名
    ///   - owner: 所属
    /// - Returns: 类实例
    public static func loadFromNib(_ bundle: Bundle = Bundle(for: Self.self as! AnyClass), named nibName: String? = nil, owner: Any? = nil) -> Self! {
        guard let result = bundle.loadNibNamed(nibName ?? "\(self)", owner: owner) else { return nil }
        return result.first { $0 is Self } as? Self
    }
}

// MARK: - Swizzle
public protocol MNSwizzleWrapper: AnyObject {}

extension MNSwizzleWrapper {
    
    /// 替换实例方法
    /// - Parameters:
    ///   - aSelector: 原方法
    ///   - newSelector: 替换的新方法
    @discardableResult
    public static func swizzleMethod(_ aSelector: Selector, with newSelector: Selector) -> Bool {
        guard let originalMethod = class_getInstanceMethod(Self.self, aSelector) else { return false }
        guard let replaceMethod = class_getInstanceMethod(Self.self, newSelector) else { return false }
        if class_addMethod(Self.self, aSelector, method_getImplementation(replaceMethod), method_getTypeEncoding(replaceMethod)) {
            class_replaceMethod(Self.self, newSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
        } else {
            method_exchangeImplementations(originalMethod, replaceMethod)
        }
        return true
    }
    
    /// 替换类方法
    /// - Parameters:
    ///   - aSelector: 原方法
    ///   - newSelector: 替换方法
    @discardableResult
    public static func swizzleClassMethod(_ aSelector: Selector, with newSelector: Selector) -> Bool {
        // 类方法列表存放在元类里, 这里要获取元类
        guard let metaClass = objc_getMetaClass(object_getClassName(Self.self)) as? AnyClass else { return false }
        guard let originalMethod = class_getClassMethod(metaClass, aSelector) else { return false }
        guard let replaceMethod = class_getClassMethod(metaClass, newSelector) else { return false }
        if class_addMethod(metaClass, aSelector, method_getImplementation(replaceMethod), method_getTypeEncoding(replaceMethod)) {
            class_replaceMethod(metaClass, newSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
        } else {
            method_exchangeImplementations(originalMethod, replaceMethod)
        }
        return true
    }
}
