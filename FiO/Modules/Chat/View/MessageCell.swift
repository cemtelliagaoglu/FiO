//
//  MessageCell.swift
//  FiO
//
//  Created by admin on 7.10.2022.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var bubbleView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bubbleView.layer.cornerRadius = bubbleView.frame.height / 10
    }
    
    func setConstraints(isSender: Bool = false){
        
        if isSender{
            bubbleView.superview!.leadingAnchor.constraint(lessThanOrEqualTo: bubbleView.leadingAnchor).isActive = true
            bubbleView.superview!.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor,constant: 5).isActive = true
            bubbleView.superview!.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: -5).isActive = true
            bubbleView.superview!.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor,constant: 5).isActive = true
        }else{
            bubbleView.superview!.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: -5).isActive = true
            bubbleView.superview!.trailingAnchor.constraint(greaterThanOrEqualTo: bubbleView.trailingAnchor).isActive = true
            bubbleView.superview!.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: -5).isActive = true
            bubbleView.superview!.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor,constant: 5).isActive = true
        }
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    
}
