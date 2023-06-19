//
//  AppManager.swift
//  Example
//
//  Created by Jiar on 2018/12/14.
//  Copyright © 2018 Jiar. All rights reserved.
//

import UIKit

class AppManager {
    static let shared = AppManager()
    
    let rootController: UITabBarController
    
    init() {
        rootController = UITabBarController()
        let homeViewController = HomeViewController()
        let exploreViewController = ExploreViewController()
        let interestViewController = InterestViewController()
        let mineViewController = MineViewController()
        rootController.viewControllers = [BaseNavigationController(rootViewController: homeViewController), BaseNavigationController(rootViewController: exploreViewController), BaseNavigationController(rootViewController: interestViewController), BaseNavigationController(rootViewController: mineViewController)]
    }
    
    func setup() {
        setupNavigationBar()
        setupTabBar()
        setupTabBarItem()
        UINavigationController.setupSwizzleForUINavigationController()
    }
    
    private func setupNavigationBar() {
        let navigationBar = UINavigationBar.appearance()
        navigationBar.isTranslucent = false
        let backImage = UIImage(named: "back")
        navigationBar.backIndicatorImage = backImage
        navigationBar.backIndicatorTransitionMaskImage = backImage
        navigationBar.tintColor = UIColor(red: 77/255.0, green: 77/255.0, blue: 77/255.0, alpha: 1.0)
        navigationBar.barTintColor = .white
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.darkGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .medium)]
        navigationBar.shadowImage = UIImage()
        navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
    
    private func setupTabBar() {
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().barTintColor = .white
        let footShadowImage = UIImage(named: "shadow")
        UITabBar.appearance().shadowImage = footShadowImage
        UITabBar.appearance().backgroundImage = UIImage()
    }
    
    private func setupTabBarItem() {
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(red: 151/255.0, green: 151/255.0, blue: 151/255.0, alpha: 1.0), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10)], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(red: 0/255.0, green: 188/255.0, blue: 212/255.0, alpha: 1.0), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10, weight: .medium)], for: .selected)
    }
    
}

extension UIViewController{
    static func instantiate(fromAppStoryboard appStoryboard: AppStoryboard) -> Self {
        return appStoryboard.viewController(self)
    }
    
    class var storyboardID : String {
        return "\(self)"
    }
}

enum AppStoryboard : String {
    case Main
}
extension AppStoryboard {
    var instance : UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    func viewController<T : UIViewController>(_ viewControllerClass : T.Type,
                        function : String = #function, // debugging purposes
                        line : Int = #line,
                        file : String = #file) -> T {
        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
        guard let scene = instance.instantiateViewController(withIdentifier: storyboardID) as? T else {
            fatalError("ViewController with identifier \(storyboardID), not found in \(self.rawValue) Storyboard.\nFile : \(file) \nLine Number : \(line) \nFunction : \(function)")
        }
        return scene
    }
    
    func initialViewController() -> UIViewController? {
        return instance.instantiateInitialViewController()
    }
}


import Foundation
enum EndPoint : String {
    case news        =  "https://api.jsonbin.io/v3/b/635249d865b57a31e69d9143"
    case news_updated  = "https://hidubaifocusapi.free.beeceptor.com/articles"
    case x_master_key = "$2b$10$YyUJiWKHl8CtW90XTkp7ru9ysDiWLhw5AsU4UTSSBgV5AUFPyxDfy"
}

public enum AppNetworkingHttpMethods: String {
    case get     = "GET"
    case post    = "POST"
    case put     = "PUT"
    case delete  = "DELETE"
    case patch   = "PATCH"
}

enum ShimmerState {
    case toBeApply // Shimmer will show
    case applied // shimmer applied
    case none // When api failed return 0 in cases
}


enum CustomError: Int, Error{
    case timeOut = -1001
    case otherError = 208
}

extension UITableView {
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
    
    func reloadTableView(){
        DispatchQueue.main.async {
            self.reloadData()
        }
    }
    ///Returns cell for the given item
    func cell(forItem item: Any) -> UITableViewCell? {
        if let indexPath = self.indexPath(forItem: item){
            return self.cellForRow(at: indexPath)
        }
        return nil
    }
    
    ///Returns the indexpath for the given item
    func indexPath(forItem item: Any) -> IndexPath? {
        let itemPosition: CGPoint = (item as AnyObject).convert(CGPoint.zero, to: self)
        return self.indexPathForRow(at: itemPosition)
    }
    
    ///Registers the given cell
    func registerClass(cellType:UITableViewCell.Type){
        register(cellType, forCellReuseIdentifier: cellType.defaultReuseIdentifier)
    }
    
    ///dequeues a reusable cell for the given indexpath
    func dequeueReusableCellForIndexPath<T: UITableViewCell>(indexPath: NSIndexPath) -> T {
        guard let cell = self.dequeueReusableCell(withIdentifier: T.defaultReuseIdentifier , for: indexPath as IndexPath) as? T else {
            fatalError( "Failed to dequeue a cell with identifier \(T.defaultReuseIdentifier). Ensure you have registered the cell." )
        }
        
        return cell
    }
    
    func indexPathForCells(inSection: Int, exceptRows: [Int] = []) -> [IndexPath] {
        let rows = self.numberOfRows(inSection: inSection)
        var indices: [IndexPath] = []
        for row in 0..<rows {
            if exceptRows.contains(row) { continue }
            indices.append([inSection, row])
        }
        
        return indices
    }
    ///Register Table View Cell Nib
    func registerCell(with identifier: UITableViewCell.Type)  {
        self.register(UINib(nibName: "\(identifier.self)",bundle:nil),
                      forCellReuseIdentifier: "\(identifier.self)")
    }
    
    ///Register Header Footer View Nib
    func registerHeaderFooter(with identifier: UITableViewHeaderFooterView.Type)  {
        self.register(UINib(nibName: "\(identifier.self)",bundle:nil), forHeaderFooterViewReuseIdentifier: "\(identifier.self)")
    }
    
    ///Dequeue Table View Cell
    func dequeueCell <T: UITableViewCell> (with identifier: T.Type, indexPath: IndexPath? = nil) -> T {
        if let index = indexPath {
            return self.dequeueReusableCell(withIdentifier: "\(identifier.self)", for: index) as! T
        } else {
            return self.dequeueReusableCell(withIdentifier: "\(identifier.self)") as! T
        }
    }
    ///Dequeue Header Footer View
    func dequeueHeaderFooter <T: UITableViewHeaderFooterView> (with identifier: T.Type) -> T {
        return self.dequeueReusableHeaderFooterView(withIdentifier: "\(identifier.self)") as! T
    }
    
    public func enablePullToRefresh(tintColor: UIColor, target: UIViewController, selector: Selector){
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(target, action: selector, for: UIControl.Event.valueChanged)
        refreshControl.tintColor = tintColor
        self.addSubview(refreshControl)
    }

}

extension UITableViewCell {
    public static var defaultReuseIdentifier: String {
        return "\(self)"
    }
}



//MARK:-
extension UICollectionView {
    
    ///Returns cell for the given item
    func cell(forItem item: AnyObject) -> UICollectionViewCell? {
        if let indexPath = self.indexPath(forItem: item){
            return self.cellForItem(at: indexPath)
        }
        return nil
    }
    
    ///Returns the indexpath for the given item
    func indexPath(forItem item: AnyObject) -> IndexPath? {
        let buttonPosition: CGPoint = item.convert(CGPoint.zero, to: self)
        return self.indexPathForItem(at: buttonPosition)
    }
    
    ///Registers the given cell
    func registerClass(cellType:UICollectionViewCell.Type){
        register(cellType, forCellWithReuseIdentifier: cellType.defaultReuseIdentifier)
    }
    
    ///dequeues a reusable cell for the given indexpath
    func dequeueReusableCellForIndexPath<T: UICollectionViewCell>(indexPath: NSIndexPath) -> T {
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: T.defaultReuseIdentifier, for: indexPath as IndexPath) as? T else {
            fatalError( "Failed to dequeue a cell with identifier \(T.defaultReuseIdentifier).  Ensure you have registered the cell" )
        }
        
        return cell
    }
    
    ///Register Collection View Cell Nib
    func registerCell(with identifier: UICollectionViewCell.Type)  {
        self.register(UINib(nibName: "\(identifier.self)", bundle: nil), forCellWithReuseIdentifier: "\(identifier.self)")
    }
    
    func registerHeaderFooer(with identifier: UICollectionReusableView.Type,kind : String)  {
        self.register(UINib(nibName: "\(identifier.self)", bundle: nil), forSupplementaryViewOfKind: kind, withReuseIdentifier: "\(identifier.self)")
    
    }
    
    ///Dequeue Collection View Cell
    func dequeueCell <T: UICollectionViewCell> (with identifier: T.Type, indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withReuseIdentifier: "\(identifier.self)", for: indexPath) as! T
    }
    
    func dequeueHeaderFooter <T: UICollectionReusableView> (with identifier: T.Type,kind: String, indexPath: IndexPath) -> T {
        return self.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "\(identifier.self)", for: indexPath) as! T

    }
    
    func reloadWithAnimation() {
        UIView.transition(with: self,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations:
            { () -> Void in
                self.reloadData()
        },completion: nil)
    }
}

extension UICollectionViewCell{
    public static var defaultReuseIdentifier:String{
        return "\(self)"
    }
}

