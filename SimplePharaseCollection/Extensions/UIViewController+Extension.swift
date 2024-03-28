//
//  UIViewController+Extension.swift
//  SimplePharaseCollection
//
//  Created by 井本智博 on 2024/03/19.
//

import UIKit

extension UIViewController {

    func presentErrorAlert(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let alertVC = ErrorAlertVC(title: title, message: message, buttonTitle: buttonTitle)
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            self.present(alertVC, animated: true, completion: nil)
        }
    }

    func presentAlert(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let alertVC = AlertVC(title: title, message: message, buttonTitle: buttonTitle)
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            self.present(alertVC, animated: true, completion: nil)
        }
    }

    func showEmptyStateView(with message: String, in view: UIView) {
        let emptyStateView = EmptyStateView(message: message)
        emptyStateView.frame = view.bounds
//        emptyStateView.tag = 100
        view.addSubview(emptyStateView)
    }

    func hideEmptyStateView() {
        (view as? EmptyStateView)?.removeFromSuperview()
    }
}

