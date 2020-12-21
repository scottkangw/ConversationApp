//
//  ConversationTableViewCell.swift
//  ConversationApp
//
//  Created by Scott.L on 21/12/2020.
//

import UIKit

class ConversationTableViewCell: UITableViewCell, NibReusable  {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

}
extension ConversationTableViewCell {
    
    func configure(chat: Conversation) {
        guard let date = chat.date else { return }
        nameLabel.text = chat.name
        dateLabel.text = reformatDate(date)
        messageLabel.text = chat.message
    }
    
    func reformatDate(_ date: String) -> String {
        guard let dateFormat = date.isoDate() else {
            let otherFormat = (date.iso8601?.timeStamp())!
            return otherFormat
        }
        return dateFormat.timeStamp()
    }
}
