//
//  FriendCell.swift
//  ListenWithMe
//
//  Created by nader said on 20/08/2022.
//

import UIKit

class FriendCell: UITableViewCell
{
    //MARK: - IBOutlet(s)
    
    @IBOutlet weak var avatarImgView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var actionBtn: UIButton!
    
    @IBOutlet weak var backView: UIView!
    {
        didSet
        {
            backView.addShadows()
        }
    }
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

    }
    
}
