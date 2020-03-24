//
//  startupScreenViewController.swift
//  drugInteractions
//
//  Created by David Rozmajzl on 3/2/20.
//  Copyright © 2020 David Rozmajzl. All rights reserved.
//

import UIKit

class startupScreenViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
        titleLabel.text = "💊"
        let titleText = K.appName.suffix(K.appName.count - 1)
        var charIndex = 0.0
        for letter in titleText {
            Timer.scheduledTimer(withTimeInterval: 0.2 * charIndex, repeats: false) { (timer) in
                self.titleLabel.text?.append(letter)
            }
            charIndex += 1
        }
    }
    
    //MARK: Functions
    func setupButtons() {
    registerButton.layer.cornerRadius = 10
    loginButton.layer.cornerRadius = 10
    }
}

