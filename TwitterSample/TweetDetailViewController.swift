import UIKit

class TweetDetailViewController : UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var userName: String = ""
    var tweetText: String = ""
    var recordDate: Date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayDetail()
        setDoneButton()
    }
    
    //これでtweetDataを渡すあ
    func configure(tweet: TweetDataModel) {
        userName = tweet.userName
        tweetText = tweet.tweetText
        recordDate = tweet.recordDate
        print("\(userName)が\(tweetText)を\(recordDate)に投稿しました")
    }
    
    func displayDetail(){
        textView.text = tweetText
        userNameLabel.text = userName
        dateLabel.text = recordDate.timeAgoDisplay()
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
}
