//
//  SongsListCell.swift
//  ListenWithMe
//
//  Created by nader said on 24/08/2022.
//

import UIKit

class SongsListCell: UITableViewCell
{

    @IBOutlet weak var singerNameLabel: UILabel!
    @IBOutlet weak var songNameLabel: UILabel!
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
