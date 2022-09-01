//
//  UIViewController.swift
//  ListenWithMe
//
//  Created by nader said on 20/08/2022.
//

import UIKit


extension UIViewController
{
    func showAlert(title: String,msg: String)
    {
        DispatchQueue.main.async
        {
            let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(action)
            self.present(alert, animated: true)
        }
    }
}

//hide keyBoard after typing in textfields
extension UIViewController
{
    func hideKeyboardWhenTappedAround()
    {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func hideKeyboard()
    {
        view.endEditing(true)
    }
}


extension UIViewController
{
    func animateConstraintsUpdate(completion: (()->())?)
    {
        UIView.animate(withDuration: 0.5)
        {[weak self] in
            guard let self = self else { return }
            self.view.layoutIfNeeded()
        } completion:
        {
            _ in
            completion?()
        }
    }
}
