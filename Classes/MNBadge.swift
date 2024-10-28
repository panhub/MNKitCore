//
//  MNBadge.swift
//  MNKit
//
//  Created by 元气绘画 on 2023/10/31.
//

import Foundation

/// 角标
public enum MNBadge {
    /// 空
    case `nil`
    /// 以数字构造
    case int(_ value: Int?)
    /// 以字符串构造
    case string(_ string: String?)
}

/// 以nil字面量构造支持
extension MNBadge: ExpressibleByNilLiteral {
    
    public init(nilLiteral: ()) {
        self = .nil
    }
}

/// 以整形字面量构造支持
extension MNBadge: ExpressibleByIntegerLiteral {
    
    public init(integerLiteral value: IntegerLiteralType) {
        self = .int(value)
    }
}

/// 以字符串字面量构造支持
extension MNBadge: ExpressibleByStringLiteral {
    
    public init(stringLiteral value: StringLiteralType) {
        self = .string(value)
    }
}

extension MNBadge {
    
    /// 整形数值
    public var rawInt: Int? {
        switch self {
        case .nil: return nil
        case .int(let value): return value
        case .string(let string):
            return NSDecimalNumber(string: string).intValue
        }
    }
    
    /// 字符串
    public var rawString: String? {
        switch self {
        case .nil: return nil
        case .string(let string): return string
        case .int(let value):
            guard let value = value else { return nil }
            return NSNumber(value: value).stringValue
        }
    }
    
    /// 是否为空
    public var isNil: Bool {
        switch self {
        case .nil: return true
        default: return false
        }
    }
}

extension Optional where Wrapped == MNBadge {
    
    /// 整形数值
    public var rawInt: Int? {
        guard let self = self else { return nil }
        return self.rawInt
    }
    
    /// 字符串
    public var rawString: String? {
        guard let self = self else { return nil }
        return self.rawString
    }
    
    /// 是否为空
    public var isNil: Bool {
        guard let self = self else { return true }
        return self.isNil
    }
}

