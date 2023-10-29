import Foundation
import UIKit
import RealmSwift

class HomeViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    //ツイートを保管する配列
    var tweetDataList:[TweetDataModel] = []
    
    override func viewDidLoad() {
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.delegate = self

        //セルの登録用
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "customCell")
        setTweetData()
        
        //画面遷移時にBackボタンを非表示
        navigationItem.hidesBackButton = true
        setNavigationBarButton()
    }
    
    //画面が表示されるたびにデータの更新が行われる
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //setTweetData()
        tableView.reloadData() //データを画面に反映させる
    }
    
    func setTweetData(){
        let realm = try! Realm()
        let result = realm.objects(TweetDataModel.self)
        tweetDataList = Array(result)
    }
    //投稿ページへの移動
    @objc func tapAddButton() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tweetPostViewController = storyboard.instantiateViewController(identifier: "TweetPostViewController") as! TweetPostViewController
        navigationController?.pushViewController(tweetPostViewController, animated: true)
    }
    
    
    func setNavigationBarButton() {
        let buttonActionSelector: Selector = #selector(tapAddButton)
        let rightBarButton = UIBarButtonItem(title: "投稿する", style: .plain, target: self, action: buttonActionSelector)
        navigationItem.rightBarButtonItem = rightBarButton
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweetDataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as? TableViewCell {
            let tweetDataModel: TweetDataModel = tweetDataList[indexPath.row]
            cell.showTexts(userName: tweetDataModel.userName, tweetText: tweetDataModel.tweetText, recordDate: tweetDataModel.recordDate)
            cell.delegate = self
            cell.indexPath = indexPath
            return cell
        }
        
        return UITableViewCell()
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

//cellをタップした際に挙動を持たせるため→UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyborad = UIStoryboard(name: "Main", bundle: nil)
        let tweetDetailViewController = storyborad.instantiateViewController(identifier: "TweetDetailViewController") as! TweetDetailViewController
        let tweetData = tweetDataList[indexPath.row]
        tweetDetailViewController.configure(tweet: tweetData)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//編集ボタンをクリック時にTweetDetailViewController画面に移動
extension HomeViewController: TableViewCellDelegate {
    func didTapEditButton(at indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil) // Storyboardの名前を"Main"と仮定しています
        if let tweetDetailViewController = storyboard.instantiateViewController(withIdentifier: "TweetDetailViewController") as? TweetDetailViewController {
            let tweetData = tweetDataList[indexPath.row] // tweetDataListはHomeViewController内で定義されているデータリストと仮定
            tweetDetailViewController.configure(tweet: tweetData)
            navigationController?.pushViewController(tweetDetailViewController, animated: true)
            print("\(indexPath.row)番を編集します")
        }
    }
    
    func didTapDeleteButton(at indexPath: IndexPath) {
        let targetTweet = tweetDataList[indexPath.row]
        let realm = try! Realm()
        try! realm.write {
            realm.delete(targetTweet)
        }
        tweetDataList.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}

