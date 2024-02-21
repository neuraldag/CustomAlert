//
//  ViewController.swift
//  Test
//
//  Created by Gamid Gapizov on 21.02.2024.
//

import UIKit

class ViewController: UIViewController {
 
    let setButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(setButton)
        setButton.configuration = .filled()
        setButton.frame = .init(x: 100, y: 400, width: 200, height: 60)
        setButton.addTarget(self, action: #selector(showAlert), for: .touchUpInside)
        setButton.setTitle("Удалить", for: .normal)
    }

    
    @objc func showAlert(_ sender: Any) {
        print("tapped")
        let alertView = AlertView(title: "Удалить папку «Непрочитанные»?", message: "Это не затронет чаты, которые в ней находятся", rightButtonText: "Удалить", leftButtonText: "Отменить") { (_, button) in
            if button == .other { }
        }
        alertView.show(animated: true)
    }
    
}

// MARK: - AlertView Delegate
extension ViewController: AlertViewDelegate {
    func alertView(alertView: AlertView, clickedButtonAtIndex buttonIndex: Int) { }
}

