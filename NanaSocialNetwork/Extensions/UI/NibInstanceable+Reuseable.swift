//
//  NibInstanceable.swift
//  NanaSocialNetwork
//
//  Created by Teerapat on 6/21/21.
//

import UIKit

protocol NibInstanceable {
    static func nibName() -> String
}

extension NibInstanceable where Self: UIView {

    /**
     Create and UIView and subclass instance from a nib in the Main bundle.

     Force un-wrap is used as early exception in case can not find a suitable instance.

     - Returns: Instance from nib resource.
     */
    static func nibInstance() -> Self {
        return Bundle.main.loadNibNamed(Self.nibName(), owner: nil, options: nil)?.first as! Self
    }
}

extension NibInstanceable {
    /**
     Create a UINib instance from nib name and bundle

     - Parameter bundle: the bundle contains nib

     - Returns: Instance of UINib
     */
    static func nib(inBundle bundle: Bundle? = nil) -> UINib {
        return UINib(nibName: nibName(), bundle: bundle)
    }
}

protocol Reuseable {
    static var reuseId: String { get }
}

typealias NibAndReuseable = NibInstanceable & Reuseable

extension UITableView {
    func dequeueCell<T: NibAndReuseable & UITableViewCell>(_ type: T.Type, at indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: T.reuseId, for: indexPath) as! T
    }

    func dequeueView<T: NibAndReuseable & UITableViewHeaderFooterView>(_ type: T.Type) -> T {
        return dequeueReusableHeaderFooterView(withIdentifier: T.reuseId) as! T
    }

    func registerCell<T: NibAndReuseable & UITableViewCell>(_ type: T.Type) {
        register(T.nib(), forCellReuseIdentifier: T.reuseId)
    }

    func registerView<T: NibAndReuseable & UITableViewHeaderFooterView>(_ type: T.Type) {
        register(T.nib(), forHeaderFooterViewReuseIdentifier: T.reuseId)
    }
}

extension UICollectionView {
    func dequeueCell<T: NibAndReuseable & UICollectionViewCell>(_ type: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: T.reuseId, for: indexPath) as! T
    }

    func dequeueView<T: NibAndReuseable & UICollectionReusableView>(_ type: T.Type, ofKind kind: String, for indexPath: IndexPath) -> T {
        return dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: T.reuseId, for: indexPath) as! T
    }
    func dequeueHeaderView<T: NibAndReuseable & UICollectionReusableView>(_ type: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: T.reuseId, for: indexPath) as! T
    }
    func dequeueFooterView<T: NibAndReuseable & UICollectionReusableView>(_ type: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: T.reuseId, for: indexPath) as! T
    }

    func registerCell<T: NibAndReuseable & UICollectionViewCell>(_ type: T.Type) {
        register(T.nib(), forCellWithReuseIdentifier: T.reuseId)
    }

    /// Register nib to collection view as reuseable header or footer
    ///
    /// - Parameters:
    ///   - type: type of nib will be registered for reuse
    ///   - kind: kind of section view. only accept **UICollectionView.elementKindSectionHeader** or **UICollectionView.elementKindSectionFooter**
    func registerView<T: NibAndReuseable & UICollectionReusableView>(_ type: T.Type, ofKind kind: String) {
        guard kind == UICollectionView.elementKindSectionHeader || kind == UICollectionView.elementKindSectionFooter else {
            fatalError("Oop!. Can not register view to collectionview. Only accep kind as UICollectionView.elementKindSectionHeader or UICollectionView.elementKindSectionFooter")
        }
        register(T.nib(), forSupplementaryViewOfKind: kind, withReuseIdentifier: T.reuseId)
    }

    func registerHeaderView<T: NibAndReuseable & UICollectionReusableView>(_ type: T.Type) {
        register(T.nib(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: T.reuseId)
    }

    func registerFooterView<T: NibAndReuseable & UICollectionReusableView>(_ type: T.Type) {
        register(T.nib(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: T.reuseId)
    }
}
