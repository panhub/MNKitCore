//
//  MNHelper.swift
//  MNKit
//
//  Created by 冯盼 on 2022/8/2.
//  核心扩展方法

import UIKit
import Foundation
import CoreGraphics

// MARK: - UIApplication
extension UIApplication {
    
    /// 状态栏高度
    @objc public static let StatusBarHeight: CGFloat = {
        if #available(iOS 13.0, *) {
            guard let statusBarManager = UIApplication.shared.delegate?.window??.windowScene?.statusBarManager else { return 0.0 }
            return statusBarManager.statusBarFrame.height
        } else {
            return UIApplication.shared.statusBarFrame.height
        }
    }()
}

// MARK: - UITabBar
extension UITabBar {
    
    /// 标签栏高度
    @objc public static let Height: CGFloat = {
        var height: CGFloat = 0.0
        if Thread.isMainThread {
            height = UITabBarController().tabBar.frame.height
        } else {
            DispatchQueue.main.sync {
                height = UITabBarController().tabBar.frame.height
            }
        }
        return height
    }()
}

// MARK: - UINavigationBar
extension UINavigationBar {
    
    /// 导航栏高度
    @objc public static let Height: CGFloat = {
        var height: CGFloat = 0.0
        if Thread.isMainThread {
            height = UINavigationController().navigationBar.frame.height
        } else {
            DispatchQueue.main.sync {
                height = UINavigationController().navigationBar.frame.height
            }
        }
        return height
    }()
}

// MARK: - UIWindow
extension UIWindow {
    
    /// 安全区域
    @objc public static let Safe: UIEdgeInsets = {
        var inset: UIEdgeInsets = .zero
        if #available(iOS 11.0, *) {
            if Thread.isMainThread {
                inset = UIWindow().safeAreaInsets
            } else {
                DispatchQueue.main.sync {
                    inset = UIWindow().safeAreaInsets
                }
            }
        }
        return inset
    }()
}

// MARK: - UIScreen
extension UIScreen {
    /// 屏幕宽/高最小值
    @objc public static let Min = {
        if #available(iOS 13.0, *), let screen = UIApplication.shared.delegate?.window??.windowScene?.screen {
            return min(screen.bounds.width, screen.bounds.height)
        }
        let window = UIWindow()
        let screen = window.screen
        if screen.bounds.width > 0.0, screen.bounds.height > 0.0 {
            return min(screen.bounds.width, screen.bounds.height)
        }
        return min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
    }()
    /// 屏幕宽/高最大值
    @objc public static let Max = {
        if #available(iOS 13.0, *), let screen = UIApplication.shared.delegate?.window??.windowScene?.screen {
            return max(screen.bounds.width, screen.bounds.height)
        }
        let window = UIWindow()
        let screen = window.screen
        if screen.bounds.width > 0.0, screen.bounds.height > 0.0 {
            return max(screen.bounds.width, screen.bounds.height)
        }
        return max(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
    }()
    /// 屏幕宽
    @objc public static var Width: CGFloat {
        if #available(iOS 13.0, *), let screen = UIApplication.shared.delegate?.window??.windowScene?.screen {
            return screen.bounds.width
        }
        return UIScreen.main.bounds.width
    }
    /// 屏幕高
    @objc public static var Height: CGFloat {
        if #available(iOS 13.0, *), let screen = UIApplication.shared.delegate?.window??.windowScene?.screen {
            return screen.bounds.height
        }
        return UIScreen.main.bounds.height
    }
}

// MARK: - UIResponder
extension UIResponder {
    
    /// 寻找符合条件的响应者
    /// - Parameter cls: 指定类型
    /// - Returns: 响应者
    public func seek<T>(as cls: T.Type) -> T? {
        var next = next
        while let responder = next {
            if responder is T { return responder as? T }
            next = responder.next
        }
        return nil
    }
}

// MARK: - Bundle
extension Bundle {
    
    /// 获取资源束 (先查询主目录再查询框架内部)
    /// - Parameter name: 名称
    @objc public convenience init?(name: String) {
        guard let bundlePath = Bundle.main.path(forResource: name, ofType: "bundle") ?? Bundle.mn.path(forResource: name, ofType: "bundle") else { return nil }
        self.init(path: bundlePath)
    }
    
    /// 获取资源束内图片
    /// - Parameters:
    ///   - name: 图片名
    ///   - ext: 扩展名
    ///   - subpath: 所在文件夹
    /// - Returns: 图片
    @objc public func image(named name: String, type ext: String = "png", directory subpath: String? = nil) -> UIImage? {
        var imagePath: String?
        if name.contains("@") {
            imagePath = path(forResource: name, ofType: ext, inDirectory: subpath)
        } else {
            var scale: Int = 3
            while scale > 0 {
                let suffix: String = scale > 1 ? "@\(scale)x" : ""
                if let path = path(forResource: name + suffix, ofType: ext, inDirectory: subpath) {
                    imagePath = path
                    break
                }
                scale -= 1
            }
        }
        guard let imagePath = imagePath else { return nil }
        return UIImage(contentsOfFile: imagePath)
    }
}

extension NameSpaceWrapper where Base: Bundle {
    
    /// MNKit.bundle
    public static var kit: Bundle? {
        guard let bundlePath = Bundle.mn.path(forResource: MN_KIT_NAME, ofType: "bundle") else { return nil }
        return Bundle(path: bundlePath)
    }
    
    public class func path(forResource name: String?, ofType ext: String?) -> String? {
#if canImport(MNKit)
        return Bundle.main.path(forResource: name, ofType: ext, inDirectory: "MNKit.framework")
#else
        return Bundle.main.path(forResource: name, ofType: ext)
#endif
    }

    public class func paths(forResourcesOfType ext: String?) -> [String]? {
#if canImport(MNKit)
        return Bundle.main.paths(forResourcesOfType: ext, inDirectory: "MNKit.framework")
#else
        return Bundle.main.paths(forResourcesOfType: ext, inDirectory: nil)
#endif
    }
    
    public class func url(forResource name: String?, withExtension ext: String?) -> URL? {
#if canImport(MNKit)
        return Bundle.main.url(forResource: name, withExtension: ext, subdirectory: "MNKit.framework")
#else
        return Bundle.main.url(forResource: name, withExtension: ext)
#endif
    }
    
    public class func urls(forResourcesWithExtension ext: String?, subdirectory subpath: String?) -> [URL]? {
#if canImport(MNKit)
        return Bundle.main.urls(forResourcesWithExtension: ext, subdirectory: "MNKit.framework")
#else
        return Bundle.main.urls(forResourcesWithExtension: ext, subdirectory: nil)
#endif
    }
}
