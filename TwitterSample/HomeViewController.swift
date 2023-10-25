//
//  HomeViewController.swift
//  TwitterSample
//
//  Created by Yota Yamashita on 2023/10/25.
//

import Foundation
import UIKit

class HomeViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    //ツイートを保管する配列
    var tweetDataList:[TweetDataModel] = []
    
    override func viewDidLoad() {
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        print("配列に追加")
        setTweetData()
        
    }
    
    func setTweetData(){
        for i in 1...5 {
            let tweetDataModel = TweetDataModel(userName: "\(i)番目のユーザー", text: "\(i)番目のツイートです", recordDate: Date())
            tweetDataList.append(tweetDataModel)
        }
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweetDataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let tweetDataModel: TweetDataModel = tweetDataList[indexPath.row]
        
        let combinedText = "@\(tweetDataModel.userName)    \(tweetDataModel.recordDate.timeAgoDisplay())"
        cell.textLabel?.text = combinedText
        cell.textLabel?.font = UIFont.systemFont(ofSize: 10) // 必要に応じてサイズを調整
        
        cell.detailTextLabel?.text = "\(tweetDataModel.text)"
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 14)
        
        return cell
    }
}

//時間の表示形式を何分前に投稿したかに変更するためのextension
extension Date {
    func timeAgoDisplay() -> String {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.minute, .hour, .day], from: self, to: now)
        
        if let day = components.day, day >= 1 {
            return "\(day)日前"
        }
        
        if let hour = components.hour, hour >= 1 {
            return "\(hour)時間前"
        }
        
        if let minute = components.minute, minute >= 1 {
            return "\(minute)分前"
        }
        
        return "たった今"
    }
}

