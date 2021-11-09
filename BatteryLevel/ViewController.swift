//
//  ViewController.swift
//  BatteryLevel
//
//  Created by giggs on 2021/10/20.
//

import UIKit

class ViewController: UIViewController {

    private let qLevel: CGFloat = 1
    private lazy var qqView = BatteryLevelView()
    private lazy var qqButton: UIButton = {
        let o = UIButton()
        o.titleLabel?.adjustsFontSizeToFitWidth = true
        o.setTitle("QQ", for: .normal)
        o.backgroundColor = UIColor.magenta
        o.addTarget(self, action: #selector(qqButtonDidTap(sender:)), for: .touchUpInside)
        
        return o
    }()
    private var mockTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        attachQQView()
        attachQQButton()
        qqView.level = 90.0
        qqView.isCharging = true
//        mock()
        
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
    
    private func attachQQButton() -> Void {
        qqButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(qqButton)
        
        NSLayoutConstraint.activate([
            qqButton.topAnchor.constraint(equalTo: qqView.bottomAnchor, constant: 20.0),
            qqButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            qqButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100.0),
            qqButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100.0),
            qqButton.heightAnchor.constraint(equalTo: qqButton.widthAnchor, multiplier: 41.0 / 135.0)
        ])
    }
    
    @objc private func qqButtonDidTap(sender: UIButton) -> Void {
        let ac = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        
        let startAct = UIAlertAction.init(title: "start animation", style: .default) { [weak self] _ in
            self?.qqView.isCharging = true
        }
        
        let stopAct = UIAlertAction.init(title: "stop animation", style: .default) { [weak self] _ in
            self?.qqView.isCharging = false
        }
        
        let incAct = UIAlertAction.init(title: "level + \(qLevel)", style: .default) { [weak self] _ in
            guard let self = self else {
                return
            }
            
            self.cancelMock()
            self.qqView.level += self.qLevel
        }
        
        let decAct = UIAlertAction.init(title: "level - \(qLevel)", style: .default) { [weak self] _ in
            guard let self = self else {
                return
            }
            
            self.cancelMock()
            self.qqView.level -= self.qLevel
        }
        
        let mockAct = UIAlertAction.init(title: "mock", style: .default) { [weak self] _ in
            guard let self = self else {
                return
            }
            
            self.mock()
        }
        
        let cancelAct = UIAlertAction.init(title: "cancel", style: .cancel) {
            [weak self] _ in
                guard let self = self else {
                    return
                }
                
                self.cancelMock()
        }
        
        ac.addAction(startAct)
        ac.addAction(stopAct)
        ac.addAction(incAct)
        ac.addAction(decAct)
        ac.addAction(mockAct)
        ac.addAction(cancelAct)
        
        present(ac, animated: true, completion: nil)
    }
    
    private func mock() -> Void {
        var level: Int = 0
        var increase: Bool = true
        
        mockTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            DispatchQueue.main.async {
                level += increase ? 1 : -1
                if level == 0 || level == 100 {
                    increase.toggle()
                }
                
                self?.qqView.level = CGFloat(level)
                print(level)
            }
        }
    }
    
    private func cancelMock() -> Void {
        mockTimer?.invalidate()
    }

}

