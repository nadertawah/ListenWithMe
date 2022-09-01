//
//  FriendsVC.swift
//  ListenWithMe
//
//  Created by nader said on 20/08/2022.
//

import UIKit
import Combine

class HomeVC: UIViewController
{
    
    //MARK: - IBOutlet(s)
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setUI()
    }
    
    //MARK: - IBAction(s)
    
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl)
    {
        switch sender.selectedSegmentIndex
        {
            case 0:
                VM.getFriends()
                break
            case 1:
            VM.searchByEmail(email: searchBar.text ?? "", segmentIndex: 1)
                break
            case 2:
                VM.getRequests()
                break
            default:
                break
        }
    }
    
    
    //MARK: - Var(s)
    private var VM = FriendsVM()
    private var disposeBag = [AnyCancellable]()
    
    //MARK: - Helper Funcs
    private func setUI()
    {
        searchBar.searchTextField.backgroundColor = .white

        //set search bar delegate
        searchBar.delegate = self
         
        //register cell
        tableView.register(UINib(nibName: FriendCell.reuseIdentfier, bundle: nil), forCellReuseIdentifier: FriendCell.reuseIdentfier)
        
        //bind VM
        VM.$filteredUsers.receive(on: DispatchQueue.main).sink
        {
            [weak self] _ in
            self?.tableView.reloadData()
        }.store(in: &disposeBag)
        
        self.hideKeyboardWhenTappedAround()
    }
    
    @objc private func cellActionBtnPressed(_ sender : UIButton)
    {
        if sender.image(for: .normal) != UIImage(systemName: "person.fill.checkmark")
        {
            switch segmentedControl.selectedSegmentIndex
            {
                case 0:
                VM.removeFriend(index: sender.tag)
                    break
                case 1:
                    VM.sendFriendRequest(index: sender.tag)
                    sender.setImage(UIImage(systemName: "person.fill.checkmark"), for: .normal)
                    break
                case 2:
                    VM.acceptFriendRequest(index: sender.tag)
                
                    break
                default:
                    break
            }
        }
        else
        {
            VM.removeFriendRequest(index: sender.tag)
            sender.setImage(UIImage(systemName: "person.fill.badge.plus"), for: .normal)
        }
    }
    
}
//MARK: - table view delegate funcs
extension HomeVC : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        VM.filteredUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FriendCell.reuseIdentfier) as? FriendCell else {return UITableViewCell()}
        let user = VM.filteredUsers[indexPath.row]
        cell.avatarImgView.image = UIImage.imageFromString(imgSTR: user.avatar)?.circleMasked
        cell.nameLabel.text = user.fullName
        
        var isFriend = false
        var actionBtnImage : UIImage?
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            actionBtnImage = UIImage(systemName: "person.fill.badge.minus")
            break
        case 1:
            actionBtnImage = VM.filteredUsers[indexPath.row].friendRequests.contains(Helper.getCurrentUserID()) ? UIImage(systemName: "person.fill.checkmark") : UIImage(systemName: "person.fill.badge.plus")
            isFriend = VM.filteredUsers[indexPath.row].friends.contains(Helper.getCurrentUserID())
            break
        case 2:
            actionBtnImage = UIImage(systemName: "person.fill.badge.plus")
            break
        default:
            break
        }
        
        cell.actionBtn.tag = indexPath.row
        cell.actionBtn.setImage(actionBtnImage, for: .normal)
        cell.actionBtn.addTarget(nil, action: #selector(cellActionBtnPressed(_:)), for: .touchUpInside)
        cell.actionBtn.isHidden  = isFriend
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if segmentedControl.selectedSegmentIndex == 0
        {
            let vc = PlayerVC(friend: VM.filteredUsers[indexPath.row])
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension HomeVC : UISearchBarDelegate
{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        searchBar.text = searchText.lowercased()
        VM.searchByEmail(email: searchText.lowercased(), segmentIndex: segmentedControl.selectedSegmentIndex)
    }
}
