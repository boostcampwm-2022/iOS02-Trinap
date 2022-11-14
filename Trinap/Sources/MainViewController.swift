//
//  MainViewController.swift
//  Trinap
//
//  Created by 김세영 on 2022/11/14.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseFirestore

class MainViewController: UIViewController {
    private lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("Fucking Tuist", for: .normal)
        button.addTarget(self, action: #selector(tappedButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var dbdb: Firestore = Firestore.firestore()
    var ref: DocumentReference?
    
    
    override func viewDidLoad() {
        view.backgroundColor = .systemPink
        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc private func tappedButton(_ sender: UIButton) {
        ref = dbdb.collection("photographers")
            .addDocument(data: [
                "possibleDates": Date(),
                "introduction": "someintroduction",
                "location": UUID().uuidString,
                "photographerId": UUID().uuidString,
                "pictures": [],
                "pricePerHalfHour": 10000,
                "status": "s033",
                "tag": ["1", "2", "3"],
                "user": "/users/d7MTE9ZYLNg6JQOK4dQ0"
            ]) { err in
                print("mdfsk;jnagio;engl;knlwegr")
                if let err {
                    print(err.localizedDescription)
                } else {
                    print("?!")
                }
            }
    }
}
