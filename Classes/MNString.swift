//
//  MNString.swift
//  MNKit
//
//  Created by 元气绘画 on 2023/10/31.
//

import Foundation

/// 富文本/字符串
public enum MNString {
    /// 空内容
    case `nil`
    /// 内容(attributes有值表示富文本, 空则表示字符串)
    case content(_ string: String, attributes: [NSAttributedString.Key:Any]? = nil)
}

/// 以nil字面量构造支持
extension MNString: ExpressibleByNilLiteral {
    
    public init(nilLiteral: ()) {
        self = .nil
    }
}

/// 以字符串字面量构造支持
extension MNString: ExpressibleByStringLiteral {
    
    public init(stringLiteral value: StringLiteralType) {
        self = .content(value)
    }
}

extension MNString {
    
    /// 字符串
    public var rawString: String? {
        switch self {
        case .nil: return nil
        case .content(let string, _): return string
        }
    }
    
    /// 富文本
    public var rawAttributedString: NSAttributedString? {
        switch self {
        case .nil: return nil
        case .content(let string, let attributes):
            guard let attributes = attributes else { return nil }
            return NSAttributedString(string: string, attributes: attributes)
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

extension Optional where Wrapped == MNString {
    
    /// 字符串
    public var rawString: String? {
        guard let self = self else { return nil }
        return self.rawString
    }
    
    /// 整形数值
    public var rawAttributedString: NSAttributedString? {
        guard let self = self else { return nil }
        return self.rawAttributedString
    }
    
    /// 是否为空
    public var isNil: Bool {
        guard let self = self else { return true }
        return self.isNil
    }
}

extension NSAttributedString {
    
    /// 以框架内字符串构造
    /// - Parameters:
    ///   - string: 字符串
    ///   - attributes: 富文本属性描述
    public convenience init?(string: MNString, attributes: [NSAttributedString.Key : Any]? = nil) {
        if let attributedString = string.rawAttributedString {
            self.init(attributedString: attributedString)
        } else if let string = string.rawString {
            self.init(string: string, attributes: attributes)
        } else {
            return nil
        }
    }
}

