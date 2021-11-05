//
//  ViewController.swift
//  BatteryLevel
//
//  Created by giggs on 2021/10/20.
//

import UIKit

class ViewController: UIViewController {

    private lazy var qqView = BatteryLevelView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        attachQQView()
//        qqView.level = 20.0
        mock()
        
    }
    private func attachQQView() -> Void {
        qqView.insets = UIEdgeInsets(top: 2.0, left: 2.0, bottom: 2.0, right: 2.0)
        
        qqView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(qqView)
        
        NSLayoutConstraint.activate([
            qqView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            qqView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            qqView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            qqView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
            qqView.heightAnchor.constraint(equalTo: qqView.widthAnchor, multiplier: 41.0 / 135.0),
//            qqView.heightAnchor.constraint(equalToConstant: 20.0)
        ])
    }
    
    private func mock() -> Void {
        var level: Int = 0
        var increase: Bool = true
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            DispatchQueue.main.async {
                level += increase ? 5 : -5
                if level == 0 || level == 100 {
                    increase.toggle()
                }
                
                self?.qqView.level = CGFloat(level)
                print(level)
            }
        }
    }

}

