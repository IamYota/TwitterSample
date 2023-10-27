import UIKit
import RealmSwift

class TweetDetailViewController : UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var tweetData = TweetDataModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayDetail()
        setDoneButton()
        textView.delegate = self
    }
    
    //これでtweetDataを渡すあ
    func configure(tweet: TweetDataModel) {
        tweetData.userName = tweet.userName
        tweetData.tweetText = tweet.tweetText
        tweetData.recordDate = tweet.recordDate
    }
    
    func displayDetail(){
        textView.text = tweetData.tweetText
        userNameLabel.text = tweetData.userName
        dateLabel.text = tweetData.recordDate.timeAgoDisplay()
    }
    
    @objc func tapDoneButton() {
        view.endEditing(true)
    }
    
    func setDoneButton(){
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        let commitButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(tapDoneButton))
        toolBar.items = [commitButton]
        textView.inputAccessoryView = toolBar
    }
    
    //データを保存
    func saveData(with tweetText: String){
        let realm = try! Realm()
        try! realm.write {
            tweetData.tweetText = tweetText
            tweetData.recordDate = Date()
            realm.add(tweetData)
        }
        print("tweetText: \(tweetData.tweetText), recordDate: \(tweetData.recordDate)")
    }
}

extension TweetDetailViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let updatedText = textView.text ?? ""
        saveData(with: updatedText)
    }
}
