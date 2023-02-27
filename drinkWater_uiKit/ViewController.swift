//
//  ViewController.swift
//  drinkWater_uiKit
//
//  Created by 박병훈 on 2023/01/16.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    @IBOutlet weak var waterLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var reminderLabel: UILabel!
    
    var waterIntake = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UI 설정
        view.backgroundColor = .white
        
        waterLabel.text = "0 oz"
        waterLabel.font = UIFont.systemFont(ofSize: 48)
        waterLabel.textAlignment = .center
        waterLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(waterLabel)
        
        addButton.setTitle("8 oz 추가", for: .normal)
        addButton.backgroundColor = .systemBlue
        addButton.setTitleColor(.white, for: .normal)
        addButton.addTarget(self, action: #selector(addWater), for: .touchUpInside)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addButton)
        
        reminderLabel.text = "물을 마시세요!"
        reminderLabel.font = UIFont.systemFont(ofSize: 24)
        reminderLabel.textAlignment = .center
        reminderLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(reminderLabel)
        
        // 제약 조건 설정
        NSLayoutConstraint.activate([
            waterLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            waterLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 50),
            addButton.widthAnchor.constraint(equalToConstant: 200),
            addButton.heightAnchor.constraint(equalToConstant: 50),
            reminderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            reminderLabel.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 50)
        ])
        
        requestNotificationAuthorization()
        
//        addNotifi()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("start")
    }
    
    @objc func addWater() {
        waterIntake += 8
        waterLabel.text = "\(waterIntake) oz"
    }
    
    // 알림 권한 요청
    func requestNotificationAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("알림 권한이 허용됨")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    // 앱이 foreground에서 실행 중일 때 알림 수신
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.banner)
    }
    
    func addNotifi(){
        // 알림 설정
        UNUserNotificationCenter.current().delegate = self
        
        let content = UNMutableNotificationContent()
        content.title = "물을 마시세요!"
        content.body = "당신의 목은 이미 건조해질 수 있습니다. 지금 물을 마시세요!"
        content.sound = UNNotificationSound.default
        
        // 3600 = 60분 60 = 1분 -> 초단위 임
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)

        let request = UNNotificationRequest(identifier: "waterReminder", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
}

