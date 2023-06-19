//
//  ExploreViewController.swift
//  Example
//
//  Created by Jiar on 2018/12/12.
//  Copyright © 2018 Jiar. All rights reserved.
//

import UIKit
import SegementSlide
import MJRefresh

class ExploreViewController: BaseTransparentSlideDefaultViewController {

    private var badges: [Int: BadgeType] = [:]
    
    
    init() {
        super.init(nibName: nil, bundle: nil)
        title = "Explore"
        tabBarItem = UITabBarItem(title: "Explore", image: UIImage(named: "tab_explore")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "tab_explore_sel")?.withRenderingMode(.alwaysOriginal))
        modalPresentationStyle = .fullScreen
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var attributedTexts: DisplayEmbed<NSAttributedString?> {
        return (nil, NSAttributedString(string: "Mine", attributes: UINavigationBar.appearance().titleTextAttributes))
    }
    
    override var bouncesType: BouncesType {
        return .child
    }
    
    override func segementSlideHeaderView() -> UIView {
        let headerView = ArtistHeaderView.instanciateFromNib()
        headerView.isUserInteractionEnabled = true
        headerView.contentMode = .scaleAspectFill
        headerView.mainImgView.image = UIImage(named: "cover-lion")
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 350.0).isActive = true
        return headerView
    }
    
    override var switcherConfig: SegementSlideDefaultSwitcherConfig {
        var config = super.switcherConfig
        config.type = .segement
        return config
    }
    
    override var titlesInSwitcher: [String] {
        return DataManager.shared.exploreLanguageTitles
    }
    
    override func showBadgeInSwitcher(at index: Int) -> BadgeType {
        if let badge = badges[index] {
            return badge
        } else {
            let badge = BadgeType.random
            badges[index] = badge
            return badge
        }
    }
    
    override func segementSlideContentViewController(at index: Int) -> SegementSlideContentScrollViewDelegate? {
        let vc  = NewsListVC.instantiate(fromAppStoryboard: .Main)
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let refreshHeader = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(refreshAction))
//        refreshHeader?.lastUpdatedTimeLabel.isHidden = true
//        scrollView.mj_header = refreshHeader
        defaultSelectedIndex = 0
        reloadData()
    }
    
//    @objc
//    private func refreshAction() {
//        DispatchQueue.global().asyncAfter(deadline: .now()+Double.random(in: 0..<2)) {
//            DispatchQueue.main.async { [weak self] in
//                guard let self = self else {
//                    return
//                }
//                guard let currentIndex = self.currentIndex else {
//                    return
//                }
//                self.badges[currentIndex] = BadgeType.random
//                self.reloadBadgeInSwitcher()
//                self.scrollView.mj_header.endRefreshing()
//            }
//        }
//    }

}
