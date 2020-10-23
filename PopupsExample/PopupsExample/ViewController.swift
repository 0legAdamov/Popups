//
//  ViewController.swift
//  PopupsExample
//
//  Created by Oleg Adamov on 14.10.2020.
//

import UIKit
import Popups

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.showAlert()
        }
    }
    
    
    func showAlert() {
        let alert = PopupAlert()
        let vc = PopupController()
        self.present(vc, animated: false)
    }

}

