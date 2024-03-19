//
//  UIViewController+Extension.swift
//  SimplePharaseCollection
//
//  Created by 井本智博 on 2024/03/19.
//

import UIKit

extension UIViewController {

    func presentAlertOnMainThread(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let alertVC = AlertVC(title: title, message: message, buttonTitle: buttonTitle)
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            self.present(alertVC, animated: true, completion: nil)
        }
    }

    func colorWithGradient(size: CGSize, colors: [UIColor]) -> UIColor {

        let backgroundGradientLayer = CAGradientLayer()
        backgroundGradientLayer.frame = CGRect(origin: .zero, size: size)
        backgroundGradientLayer.colors = colors.map { $0.cgColor }
        UIGraphicsBeginImageContext(size)
        backgroundGradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let backgroundColorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return UIColor(patternImage: backgroundColorImage!)
    }
}

