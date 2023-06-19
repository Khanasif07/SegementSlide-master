//
//  NewsListVC.swift
//  Example
//
//  Created by Asif Khan on 19/06/2023.
//  Copyright © 2023 Jiar. All rights reserved.
//

import UIKit
enum ScrollDirection : Int {
    case none
    case right
    case left
    case up
    case down
    case crazy
}
import SegementSlide
class NewsListVC: UIViewController,SegementSlideContentScrollViewDelegate {
    //MARK:- IBoutlets
    
    @objc
    var scrollView: UIScrollView {
        return newsTableView
    }
    
    @IBOutlet weak var popularLbl: UILabel!
    @IBOutlet var businessHeader: UIView!
    @IBOutlet weak var newsTableView: UITableView!
    //MARK:- IBProperties
    var headerView = ArtistHeaderView.instanciateFromNib()
    var isScrollingTrue: Bool = true
    lazy var viewModel = {
        NewsListViewModel()
    }()
    //    var emptyViewPersonal: EmptyView?
    //    var loadingView: LoadingView?
    var isHitApiInProgress: Bool = true
    
    internal var selectedCell: NewsTableViewCell?
    internal var selectedCellImageViewSnapshot: UIView?
    //    internal var animator: Animator?
    private var indexPath: IndexPath?
    //    internal var currentShimmerStatus: ShimmerState = .toBeApply
    var error: Error?
    
    //
    //    var stopScroll = 80.0
    internal var containerViewMinY: Float = 0.0
    var lastContentOffset: CGFloat = 0.0
    internal var headerTitle: String = "POPULAR BUSINESS"
    //MARK:- ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        newsTableView.isScrollEnabled = true
        //
        self.popularLbl.text = headerTitle
        if #available(iOS 15.0, *) {
            newsTableView.sectionHeaderTopPadding = 0.0
        }
        if #available(iOS 12.0, *) {
            if traitCollection.userInterfaceStyle == .light {
                businessHeader.layer.shadowColor = UIColor(white: 0.0, alpha: 0.3).cgColor
                businessHeader.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
                businessHeader.layer.shadowOpacity = 1.0
                businessHeader.layer.shadowRadius = 3.0
            } else {
                businessHeader.layer.shadowColor = UIColor(white: 1.0, alpha: 0.3).cgColor
                businessHeader.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
                businessHeader.layer.shadowOpacity = 1.0
                businessHeader.layer.shadowRadius = 3.0
            }
        }else {
            businessHeader.layer.shadowColor = UIColor(white: 0.0, alpha: 0.3).cgColor
            businessHeader.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
            businessHeader.layer.shadowOpacity = 1.0
            businessHeader.layer.shadowRadius = 3.0
        }
        businessHeader.backgroundColor = UIColor(named: "lightWhiteBlack")
        //
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        if let indexPath = indexPath{
            self.newsTableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        newsTableView.isScrollEnabled = isScrollingTrue
    }
    
    private func  initialSetup(){
        self.setUpTableView()
        //
        //        loadingView = LoadingView(frame: view.frame, inView: view)
        //        loadingView?.show()
        //
        self.viewModel.delegate = self
        //        self.emptyViewPersonal?.delegate = self
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0, execute: {
            self.fetchAPIData()
        })
    }
    private func setUpTableView(){
        self.newsTableView.delegate = self
        self.newsTableView.dataSource = self
        self.newsTableView.separatorColor = .clear
        self.newsTableView.separatorStyle = .none
        self.newsTableView.registerCell(with: NewsTableViewCell.self)
        //        self.headerSetup()
        //        self.newsTableView.enablePullToRefresh(tintColor: .orange, target: self, selector: #selector(refreshWhenPull(_:)))
    }
    
//    private func headerSetup(){
//        let parallexHeaderHeight = 250.0
//        self.headerView.frame = CGRect(x: 0, y: 0, width: Int(self.view.frame.width), height: Int(parallexHeaderHeight))
//        self.headerView.isUserInteractionEnabled = true
//        self.newsTableView.tableHeaderView = self.headerView
//    }
    
    private func fetchAPIData(){
        self.isHitApiInProgress = true
        self.newsTableView.reloadData()
        self.viewModel.getNewsListing()
    }
    
}

//MARK:- Extension TableView Delegate and DataSource
extension NewsListVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.newsData.isEmpty ? self.setEmptyMessage(self.viewModel.error?.localizedDescription ?? "",isTimeOutError: error?.errorCode == CustomError.timeOut.rawValue) : self.restore()
        return self.viewModel.newsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: NewsTableViewCell.self)
        let cellVM = viewModel.getCellViewModel(at: indexPath)
        cell.cellViewModel = cellVM
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath){
        let cell = tableView.cellForRow(at: indexPath)
        UIView.animate(withDuration: 0.25) {
            cell?.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath){
        let cell = tableView.cellForRow(at: indexPath)
        UIView.animate(withDuration: 0.25) {
            cell?.transform = .identity
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return businessHeader.frame.size.height
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return businessHeader
    }
}

//MARK:- Extension NewsListViewModelDelegate
extension NewsListVC: NewsListViewModelDelegate{
    func newsListingSuccess() {
        self.isHitApiInProgress = false
        DispatchQueue.main.async {
            //            self.loadingView?.hide()
            //            self.loadingView?.removeFromSuperview()
            //            self.currentShimmerStatus = .applied
            self.newsTableView.reloadData()
        }
    }
    
    func newsListingFailure(error: Error) {
        self.isHitApiInProgress = false
        self.error = error
        DispatchQueue.main.async {
            //            self.currentShimmerStatus = .none
            self.newsTableView.reloadData()
        }
    }
}


extension NewsListVC{
    func setEmptyMessage(_ message: String = "",isTimeOutError: Bool = false) {
        // Custom way to add view
        var offset:CGFloat = 0
        var bottomOffset = 0.0
        var fakenavHeightRef:CGFloat = 0.0
        if #available(iOS 13.0, *) {
            let window:UIWindow! = UIApplication.shared.keyWindow
            fakenavHeightRef =  fakenavHeightRef + window.safeAreaInsets.top
            bottomOffset =  window.safeAreaInsets.bottom
        }else {
            let window:UIWindow! = UIApplication.shared.keyWindow
            fakenavHeightRef = fakenavHeightRef + window.safeAreaInsets.top
            bottomOffset =  window.safeAreaInsets.bottom
        }
//        offset = self.navigationController?.navigationBar.height ?? 0.0
        
        // Custom way to add view
        //        if emptyViewPersonal == nil && !isHitApiInProgress{
        //            emptyViewPersonal?.removeFromSuperview()
        //            emptyViewPersonal = EmptyView(frame: CGRect(x: 0, y: fakenavHeightRef + offset, width: self.view.frame.width, height: self.view.frame.height -  fakenavHeightRef - offset - bottomOffset), inView: self.view, centered: true, icon: UIImage(named: ""), message: "")
        //            emptyViewPersonal?.delegate = self
        //            emptyViewPersonal?.show()
        //        }
    }
    
    func restore() {
        newsTableView.backgroundView = nil
        //        emptyViewPersonal?.hide()
        //        emptyViewPersonal?.removeFromSuperview()
        
    }
}

//extension NewsListVC: EmptyStateViewDelegate{
//    func loginAction() {
//        self.setEmptyMessage()
//        self.fetchAPIData()
//    }
//
//    func learnHowAction() {
//        self.setEmptyMessage()
//        self.fetchAPIData()
//    }
//
//    //Grouped BY:-
//}

