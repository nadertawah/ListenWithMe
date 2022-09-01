//
//  ProfileView.swift
//  Chatter
//
//  Created by Nader Said on 12/07/2022.
//

import UIKit
import Combine

class ProfileView: UIViewController
{
    
    //MARK: - IBOutlet(s)

    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var createdAtLabel: UILabel!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setUI()
    }

    //MARK: - IBAction(s)
    @IBAction func logOutBtnPressed(_ sender: UIButton)
    {
        VM.logout
        {
            [weak self] in
            let loginV = LoginRegisterView()
            self?.navigationController?.isNavigationBarHidden = true
            self?.navigationController?.setViewControllers([loginV], animated: true)
            self?.tabBarController?.tabBar.isHidden = true
        }
    }
    
    //MARK: - Var(s)
    private var VM = ProfileVM()
    private var disposeBag = [AnyCancellable]()
    private var avatarTapGestureRecogniser = UITapGestureRecognizer()
    private let imgController = UIImagePickerController()

    //MARK: - Helper Funcs
    func setUI()
    {
        title = "Profile"
        
        //bind to VM
        VM.$user.receive(on: DispatchQueue.main).sink
        { [weak self] user in
            guard let self = self else {return}
            DispatchQueue.main.async
            {
                self.imgView.image = UIImage.imageFromString(imgSTR: (user.avatar) )?.circleMasked
                self.nameLabel.text = "Name: " + (user.fullName)
                self.emailLabel.text = "Email: " + (user.email)
                self.createdAtLabel.text = "Created at: " + (user.createdAt.localString())
            }
        }.store(in: &disposeBag)
        
        //tap to choose avatar image
        imgView.isUserInteractionEnabled = true
        avatarTapGestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(self.avatarPressed))
        self.imgView.addGestureRecognizer(avatarTapGestureRecogniser)
        
        imgController.delegate = self
    }
    
    @objc func avatarPressed()
    {
        let alert = UIAlertController(title: "", message: "Please Select an Option", preferredStyle: .actionSheet)
            
        let showImgAction = UIAlertAction(title: "Show avatar image", style: .default)
        {
            [weak self] _ in
            guard let self = self , let avatar = UIImage.imageFromString(imgSTR: self.VM.user.avatar) else {return}
            let imgViewer = ImageViewerView(img: avatar)
            self.navigationController?.pushViewController(imgViewer, animated: true)
        }
        
        let changeImgAction = UIAlertAction(title: "Change avatar image", style: .default)
        {
            [weak self] _ in
            guard let self = self else {return}
            self.present(self.imgController, animated: true)
        }
        
        alert.addAction(showImgAction)
        alert.addAction(changeImgAction)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
        
        self.present(alert, animated: true)
    }
}


//MARK: - Image Picker delegate funcs
extension ProfileView : UIImagePickerControllerDelegate , UINavigationControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let imagePicked = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            imgView.image = imagePicked.circleMasked
            self.VM.changeAvatar(avatarStr: imagePicked.imageToString())
        }
        picker.dismiss(animated: true)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        picker.dismiss(animated: true)
    }
}
