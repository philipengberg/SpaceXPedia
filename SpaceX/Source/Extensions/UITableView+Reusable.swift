//
//  UITableView+Reusable.swift
//  SpaceX
//
//  Created by Philip Engberg on 20/08/2018.
//  Copyright © 2018 Simple Sense. All rights reserved.
//

import Foundation
import UIKit

protocol ReuseableView: class {
    static var reuseIdentifier: String { get }
}

extension ReuseableView where Self: UIView {
    static var reuseIdentifier: String {
        return NSStringFromClass(self) as String
    }
}

extension UITableViewCell: ReuseableView { }
extension UITableViewHeaderFooterView: ReuseableView { }
extension UICollectionViewCell: ReuseableView { }

extension UITableView {
    
    func registerCell<T: UITableViewCell>(_ type: T.Type) {
        self.register(type.self, forCellReuseIdentifier: type.reuseIdentifier)
    }
    
    func dequeueCell<T: UITableViewCell>(_ type: T.Type, indexPath: IndexPath) -> T {
        guard let cell = self.dequeueReusableCell(withIdentifier: type.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier \(type.reuseIdentifier). Are you sure it has been registered?")
        }
        return cell
    }
    
    func registerHeader<T: UITableViewHeaderFooterView>(_ type: T.Type) {
        self.register(type.self, forHeaderFooterViewReuseIdentifier: type.reuseIdentifier)
    }
    
    func dequeueHeader<T: UITableViewHeaderFooterView>(_ type: T.Type) -> T {
        guard let header = self.dequeueReusableHeaderFooterView(withIdentifier: type.reuseIdentifier) as? T else {
            fatalError("Could not dequeue header with identifier \(type.reuseIdentifier). Are you sure it has been registered?")
        }
        return header
    }
    
    func registerFooter<T: UITableViewHeaderFooterView>(_ type: T.Type) {
        self.register(type.self, forHeaderFooterViewReuseIdentifier: type.reuseIdentifier)
    }
    
    func dequeueFooter<T: UITableViewHeaderFooterView>(_ type: T.Type) -> T {
        guard let header = self.dequeueReusableHeaderFooterView(withIdentifier: type.reuseIdentifier) as? T else {
            fatalError("Could not dequeue footer with identifier \(type.reuseIdentifier). Are you sure it has been registered?")
        }
        return header
    }
}
