//
//  MNURL.swift
//  MNKit
//
//  Created by 元气绘画 on 2023/10/31.
//

import Foundation

/// 资源定位器
public enum MNURL {
    /// 空
    case `nil`
    /// 以资源定位器构造
    case url(_ url: URL?)
    /// 以字符串构造
    case string(_ string: String?)
}

/// 以字符串字面量构造支持
extension MNURL: ExpressibleByStringLiteral {
    
    public init(stringLiteral value: StringLiteralType) {
        self = .string(value)
    }
}

/// 以nil字面量构造支持
extension MNURL: ExpressibleByNilLiteral {
    
    public init(nilLiteral: ()) {
        self = .nil
    }
}

extension MNURL {
    
    /// 资源定位实例
    public var rawURL: URL? {
        switch self {
        case .nil: return nil
        case .url(let url): return url
        case .string(let string):
            guard let string = string else { return nil }
            if (string as NSString).isAbsolutePath {
                if #available(iOS 16.0, *) {
                    return URL(filePath: string)
                } else {
                    return URL(fileURLWithPath: string)
                }
            }
            return URL(string: string)
        }
    }
    
    /// 字符串
    public var rawString: String? {
        switch self {
        case .nil: return nil
        case .string(let string): return string
        case .url(let url):
            guard let url = url else { return nil }
            if url.isFileURL {
                if #available(iOS 16.0, *) {
                    return url.path(percentEncoded: false)
                } else {
                    return url.path
                }
            }
            return url.absoluteString
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

extension Optional where Wrapped == MNURL {
    
    /// 资源定位实例
    public var rawURL: URL? {
        guard let self = self else { return nil }
        return self.rawURL
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
