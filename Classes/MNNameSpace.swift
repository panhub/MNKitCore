//
//  MNNameSpace.swift
//  MNKit-Core
//
//  Created by pan on 2022/11/11.
//  定义命名空间

import Foundation
import ObjectiveC.runtime

/// 命名空间 后续扩展即可
public class NameSpaceWrapper<Base> {
    internal let base: Base
    public init(base: Base) {
        self.base = base
    }
}

/// 支持命名空间的协议
public protocol NameSpaceConvertible {
    
    associatedtype NameSpaceBase
    
    var mn: NameSpaceWrapper<NameSpaceBase> { get }
    
    static var mn: NameSpaceWrapper<NameSpaceBase>.Type { get }
}

/// 为命名空间添加属性
extension NameSpaceConvertible {
    
    public var mn: NameSpaceWrapper<Self> { NameSpaceWrapper<Self>(base: self) }
    
    public static var mn: NameSpaceWrapper<Self>.Type { NameSpaceWrapper<Self>.self }
}

/// 为`NSObject`添加命名空间
extension NSObject: NameSpaceConvertible {}

/// 关联属性扩展Key
public struct MNAssociatedKey {}

extension MNAssociatedKey {
    
    /// 关联用户自定义信息
    fileprivate static var mn_user_info: String = "com.mn.object.user.info"
    
    /// 第一次关联
    fileprivate static var mn_first_associated: String = "com.mn.object.first.associated"
}

/// 关联对象包装器
public class MNAssociationLitted {
    public let value: Any
    public init(value: Any) {
        self.value = value
    }
    public init(_ value: Any) {
        self.value = value
    }
}

/// 命名空间对`NSObject`的支持
extension NameSpaceWrapper where Base: NSObject {
    
    /// 关联用户保存的变量
    public var userInfo: Any? {
        set {
            if let newValue = newValue {
                let association = MNAssociationLitted(value: newValue)
                objc_setAssociatedObject(base, &MNAssociatedKey.mn_user_info, association, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            } else {
                objc_setAssociatedObject(base, &MNAssociatedKey.mn_user_info, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
        get {
            guard let association = objc_getAssociatedObject(base, &MNAssociatedKey.mn_user_info) as? MNAssociationLitted else { return nil }
            return association.value
        }
    }
    
    /// 是否第一次关联
    public var isFirstAssociated: Bool {
        if let _ = objc_getAssociatedObject(base, &MNAssociatedKey.mn_first_associated) { return false }
        objc_setAssociatedObject(base, &MNAssociatedKey.mn_first_associated, true, .OBJC_ASSOCIATION_ASSIGN)
        return true
    }
}
