//
//  NewsTableViewCell.swift
//  Example
//
//  Created by Asif Khan on 19/06/2023.
//  Copyright © 2023 Jiar. All rights reserved.
//

import UIKit
import Foundation
import Combine
class NewsTableViewCell: UITableViewCell{
    @IBOutlet weak var dataContainerView: UIView!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var tagView: UIView!
//    @IBOutlet weak var tagLbl: UserTagLabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var newsImgView: UIImageView!
    
    private lazy var setupOnce: Void = {
        self.newsImgView.layer.cornerRadius = 5.0
//        self.tagView.layer.cornerRadius = 14.0
//        self.dataContainerView.addShadow(cornerRadius: 5, color: UIColor(white: 48.0 / 255.0, alpha: 0.26), offset: CGSize(width: 0.5, height: 0.5), opacity: 1, shadowRadius: 5)
    }()
    private var cancellable: AnyCancellable?
    private var animator: UIViewPropertyAnimator?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupfont()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        animator?.stopAnimation(true)
        cancellable?.cancel()
//        newsImgView.alpha = 0.0
//        newsImgView.image = nil
        descLbl.text = nil
        timeLbl.text = nil
        titleLbl.text = nil
        dateLbl.text = nil
//        tagLbl.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        _ = setupOnce
    }
    
    private func setupfont(){
        titleLbl.font = UIFont.boldSystemFont(ofSize: 15)
        descLbl.font = UIFont.boldSystemFont(ofSize: 14)
        dateLbl.font = UIFont.boldSystemFont(ofSize: 14)
//        tagLbl.font = UIFont.boldSystemFont(ofSize: 14)
        timeLbl.font = UIFont.boldSystemFont(ofSize: 14)
        dateLbl.textColor = UIColor.systemBrown
        descLbl.textColor = .lightGray
        timeLbl.textColor = UIColor.systemBrown
        titleLbl.textColor = .black
//        self.tagView.backgroundColor = .orange
    }
    
    var cellViewModel: Record?{
        didSet{
//            tagLbl.setUserType(usertype: cellViewModel?.primaryTag ?? "")
//            tagLbl.setUserType(usertype: cellViewModel?.primaryTag ?? "")
            titleLbl.text = cellViewModel?.title
            dateLbl.text  = cellViewModel?.dateString
            descLbl.text  = cellViewModel?.content
//            tagLbl.text   = cellViewModel?.primaryTag
            timeLbl.text  = "- \(cellViewModel?.readTime ?? "")" + " min read"
        }
    }
    
//    private func showImage(image: UIImage?) {
//        newsImgView.alpha = 0.0
//        animator?.stopAnimation(false)
//        newsImgView.image = image
//        animator = UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
//            self.newsImgView.alpha = 1.0
//        })
//    }
    
//    private func loadImage(for movie: Record?) -> AnyPublisher<UIImage?, Never> {
//        return Just(movie?.postImageURL ?? "")
//            .flatMap({ poster -> AnyPublisher<UIImage?, Never> in
//                let url = URL(string: movie?.postImageURL ?? "")!
//                return ImageLoader.shared.loadImage(from: url)
//            })
//            .eraseToAnyPublisher()
//    }
}
