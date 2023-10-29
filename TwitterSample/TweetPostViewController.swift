import Foundation
import UIKit
import RealmSwift

class TweetPostViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    

    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var userNameLabel: UITextField!
    @IBOutlet weak var tweetPostField: UITextView!
    @IBOutlet weak var tweetButton: UIButton!
    @IBAction func tweetEditingDidChanged(_ sender: Any) {
    }
    
    func switchTweetButton(){
        guard let userNameText = userNameLabel.text else {
            tweetButton.isEnabled = false
            return
        }
        
        if !userNameText.isEmpty && !tweetPostField.text.isEmpty {
            tweetButton.isEnabled = true
            tweetButton.backgroundColor = UIColor.systemBlue
            tweetButton.setTitleColor(UIColor.white, for: .normal)
        } else {
            tweetButton.isEnabled = false
            tweetButton.backgroundColor = UIColor.lightGray
            tweetButton.setTitleColor(UIColor.white, for: .normal)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switchTweetButton()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        switchTweetButton()
    }
    
    
    let maxCharacterCount = 140
    
    //インスタンス化でアクセスできるように
    var tweetData = TweetDataModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDoneButton()
        tweetButton.isEnabled = false
        userNameLabel.delegate = self
        tweetPostField.delegate = self
        tweetButton.backgroundColor = UIColor.lightGray
    }
    
    @objc func tapDoneButton() {
        view.endEditing(true)
    }
    
    func setDoneButton(){
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        let commitButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(tapDoneButton))
        toolBar.items = [commitButton]
        tweetPostField.inputAccessoryView = toolBar
    }
    
    //ここでrealmに渡す。
    func saveData(with tweetText: String){
        let realm = try! Realm()
        try! realm.write {
            tweetData.userName = userNameLabel.text ?? ""
            tweetData.tweetText = tweetText
            tweetData.recordDate = Date()
            realm.add(tweetData)
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let tweetText = tweetPostField.text ?? ""
        saveData(with: tweetText)
        switchTweetButton()
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


