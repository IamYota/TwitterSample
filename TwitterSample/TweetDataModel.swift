import Foundation
import RealmSwift

class TweetDataModel: Object {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var userName: String = ""
    @objc dynamic var tweetText: String = ""
    @objc dynamic var recordDate: Date = Date()
    
    
}
