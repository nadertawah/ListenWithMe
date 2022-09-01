//
//  WalkThrough.swift
//  ListenWithMe
//
//  Created by Nader Said on 30/08/2022.
//

import UIKit

class WalkThrough
{
    init(frame:CGRect)
    {
        blurEffectView.frame = frame
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    //MARK: - Var(s)
    let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
    var step = 0
    
    //MARK: - Helper Funcs
    func next()
    {
        step += 1
    }
}
