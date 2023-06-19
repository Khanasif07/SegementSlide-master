//
//  NewsListViewModel.swift
//  Example
//
//  Created by Asif Khan on 19/06/2023.
//  Copyright © 2023 Jiar. All rights reserved.
//

import Foundation
import Foundation
protocol NewsListViewModelDelegate: NSObject {
    func newsListingSuccess()
    func newsListingFailure(error: Error)
}

class NewsListViewModel{
    
    //will implement viewmodel by implementing depedency injection like SwiftUIInUICollectionViewAndUITableView-main project
    //
    weak var delegate: NewsListViewModelDelegate?
    var newsData = [Record]()
    var error : Error?
    func getNewsListing(){
        NetworkManager.shared.getDataFromServer(requestType: .get, endPoint: "https://api.jsonbin.io/v3/b/635249d865b57a31e69d9143") { (results : Result<News,Error>)  in
            switch results{
            case .success(let result):
                self.newsData = result.record
//                self.newsData.append(contentsOf: result.record)
                //todo
                self.newsData[0].isSelected = true
                self.delegate?.newsListingSuccess()
            case .failure(let error):
                self.error = error
                self.newsData = []
                self.delegate?.newsListingFailure(error: error)
            }
        }
    }
    
    func getCellViewModel(at indexpath: IndexPath) -> Record{
        return newsData[indexpath.row]
    }
}
