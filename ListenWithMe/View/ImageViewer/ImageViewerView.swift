//
//  ImageViewerView.swift
//  Chatter
//
//  Created by nader said on 14/07/2022.
//

import UIKit

class ImageViewerView: UIViewController
{

    //MARK: - IBOutlet(s)
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.isNavigationBarHidden = true

    }
    init(img : UIImage)
    {
        image = img
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Var(s)
    var image : UIImage!
    
    //MARK: - Helper Funcs
    func setUI()
    {
        imageView.image = image
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 3.0
    }
    
}


extension ImageViewerView : UIScrollViewDelegate
{
    func viewForZooming(in scrollView: UIScrollView) -> UIView?
    {
        imageView
    }
}
