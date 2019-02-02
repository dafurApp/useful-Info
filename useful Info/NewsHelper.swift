//
//  NewsHelper.swift
//  useful Info
//
//  Created by Daniel Furrer on 02.02.19.
//  Copyright © 2019 Daniel Furrer. All rights reserved.
//

import Foundation
import Alamofire

class NewsHelper {
    
    let myAPI = "36307fbd5dfc41d795f8f456b1c0873c"
    let myCT = "CH"
    
    func getArticles(returnArticles : @escaping ([Article]) -> Void) {
        
        Alamofire.request("https://newsapi.org/v2/top-headlines?country=\(self.myCT)&apiKey=\(self.myAPI)").responseJSON { (response) in
            print(response)
            
            if let json = response.result.value as? [String:Any] {
                if let jsonArticles = json["articles"] as? [[String:Any]] {
                    var articles = [Article]()
                    for jsonArticle in jsonArticles {
                        guard let title = jsonArticle["title"] as? String,
                            let urlToImage = jsonArticle["urlToImage"] as? String,
                            let url = jsonArticle["url"] as? String,
                            let description = jsonArticle["description"] as? String
                            else {
                                continue
                        }
                        let article = Article()
                        article.title = title
                        article.urlToImage = urlToImage
                        article.url = url
                        article.description = description
                        articles.append(article)
                        }
                    returnArticles(articles)
                    }
                
                }
            }
        }
        
    }
    








class Article {
    var title = ""
    var urlToImage = ""
    var url = ""
    var description = ""
   
}
