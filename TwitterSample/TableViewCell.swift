import UIKit

protocol TableViewCellDelegate: AnyObject {
    func didTapEditButton(at indexPth: IndexPath)
    func didTapDeleteButton(at indexPath: IndexPath)
}

class TableViewCell: UITableViewCell {
    
    weak var delegate: TableViewCellDelegate?
    var indexPath: IndexPath!
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var postedTimeLabel: UILabel!
    
    @IBAction func editButton(_ sender: Any) {
        delegate?.didTapEditButton(at: indexPath)
    }
    
    @IBAction func deleteButton(_ sender: Any) {
        delegate?.didTapDeleteButton(at: indexPath)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //いったんカスタムセルのダミーデータ用にコード上で入力するように
    func showTexts(userName: String, tweetText: String, recordDate: Date) {
        userNameLabel.text = userName
        tweetTextLabel.text = tweetText
        postedTimeLabel.text = recordDate.timeAgoDisplay()
    }
}
