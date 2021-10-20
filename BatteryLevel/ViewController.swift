//
//  ViewController.swift
//  BatteryLevel
//
//  Created by giggs on 2021/10/20.
//

import UIKit

class ViewController: UIViewController {

    private lazy var levelView = BatteryLevelView(frame: CGRect(origin: .zero, size: .zero))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        attachLevelView()
        //        levelView.level = 50.0
        mock()
    }
    
    private func attachLevelView() -> Void {
//        levelView.batteryInsets = UIEdgeInsets(top: 2.0, left: 2.0, bottom: 2.0, right: 2.0)
        levelView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(levelView)
        
        NSLayoutConstraint.activate([
            levelView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            levelView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            levelView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            levelView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
            levelView.heightAnchor.constraint(equalTo: levelView.widthAnchor, multiplier: 41.0 / 135.0)
        ])
    }
    
    private func mock() -> Void {
        var level: Int = 0
        var increase: Bool = true
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            DispatchQueue.main.async {
                level += increase ? 1 : -1
                if level == 0 || level == 100 {
                    increase.toggle()
                }
                
                self?.levelView.level = CGFloat(level)
            }
        }
    }

}

