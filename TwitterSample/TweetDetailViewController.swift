import UIKit
import RealmSwift

class TweetDetailViewController : UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    @IBOutlet weak var editDoneButton: UIButton!
    
    @IBAction func TweetEditinDidChanged(_ sender: Any) {
    }
    
    
    func switchTweetButton(){
        if textView.text.isEmpty {
            editDoneButton.isEnabled = false
            editDoneButton.backgroundColor = UIColor.lightGray
            editDoneButton.setTitleColor(UIColor.white, for: .normal)
        } else {
            editDoneButton.isEnabled = true
            editDoneButton.backgroundColor = UIColor.systemBlue
            editDoneButton.setTitleColor(UIColor.white, for: .normal)
        }
    }
    
    private func textViewDidEndEditing(_ textView: UITextField) {
        switchTweetButton()
    }
    
    
    
    var tweetData = TweetDataModel()
    let maxCharacterCount = 140
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayDetail()
        setDoneButton()
        textView.delegate = self
        editDoneButton.backgroundColor = UIColor.lightGray
    }
    
    //tweetDataを渡す
    func configure(tweet: TweetDataModel) {
//        tweetData.userName = tweet.userName.self
//        tweetData.tweetText = tweet.tweetText.self
//        tweetData.recordDate = tweet.recordDate.self
        tweetData = tweet
    }
    
    func displayDetail(){
        textView.text = tweetData.tweetText
        userNameLabel.text = tweetData.userName

        //viewdidloadで画面が表示された時に文字数を表示したいのでこのメソッド内に記述
        dateLabel.text = tweetData.recordDate.timeAgoDisplay()
        countLabel.text = "\(tweetData.tweetText.count) / \(maxCharacterCount)文字"
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
    
    func textViewDidChange(_ textView: UITextView) {
        let updatedText = textView.text ?? ""
        switchTweetButton()
        saveData(with: updatedText)
        countLabel.text = "\(textView.text.count)/\(maxCharacterCount)文字"
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newCharacterCount = textView.text.count - range.length + text.count
        
        if newCharacterCount >= maxCharacterCount {
            countLabel.textColor = .red
        }
        return (newCharacterCount <= maxCharacterCount)
    }
}

