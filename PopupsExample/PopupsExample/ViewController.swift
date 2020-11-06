//
//  ViewController.swift
//  PopupsExample
//
//  Created by Oleg Adamov on 14.10.2020.
//

import UIKit
import Popups
import RxSwift


private struct Example {
    
    let text: String
    let action: () -> Void
}

class ViewController: UIViewController {
    
    private var alerts = [Example]()
    private var actions = [Example]()
    private let disposeBag = DisposeBag()

    private lazy var backgroundView: UIImageView = {
        let imView = UIImageView(image: UIImage(named: "img")!)
        imView.contentMode = .scaleAspectFill
        return imView
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: view.bounds, style: .grouped)
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = .clear
        table.separatorStyle = .none
        table.register(TableViewCell.self, forCellReuseIdentifier: "TableCell")
        return table
    }()
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        alerts.append(Example(text: "No description", action: { [unowned self] in
            let alert = PopupAlert(title: "Alert without description")
            let vc = PopupController(model: alert)
            
            let done = PopupAlertButton(title: "Done")
            done.onAction
                .subscribe { _ in
                    print("btn: next")
                }
                .disposed(by: disposeBag)
            alert.buttons.append(done)
            
            Observable.combineLatest([done.onAction, vc.onDismiss])
                .ignoreElements()
                .subscribe(onCompleted: {
                    print("On Complete")
                })
                .disposed(by: disposeBag)
            
            self.present(vc, animated: false)
        }))
        
        alerts.append(Example(text: "With Description", action: { [unowned self] in
            let alert = PopupAlert(title: "Alert with description", subtitle: "Some example description for alert view demo in two strings")
            let done = PopupAlertButton(title: "Done")
            alert.buttons.append(done)
            let vc = PopupController(model: alert)
            self.present(vc, animated: false)
        }))
        
        alerts.append(Example(text: "Two actions", action: { [unowned self] in
            let alert = PopupAlert(title: "Alert without description")
            let vc = PopupController(model: alert)
            
            let done = PopupAlertButton(title: "Remove")
            done.destructive = true
            alert.buttons.append(done)
            
            let cancel = PopupAlertButton(title: "Cancel")
            cancel.boldTitle = true
            alert.buttons.append(cancel)
            
            self.present(vc, animated: false)
        }))
        
        alerts.append(Example(text: "Three actions", action: { [unowned self] in
            let alert = PopupAlert(title: "Alert without description")
            let vc = PopupController(model: alert)
            
            let action = PopupAlertButton(title: "Action")
            alert.buttons.append(action)
            
            let remove = PopupAlertButton(title: "Remove")
            remove.destructive = true
            alert.buttons.append(remove)
            
            let cancel = PopupAlertButton(title: "Cancel")
            cancel.boldTitle = true
            alert.buttons.append(cancel)
            
            Observable.combineLatest([action.onAction, remove.onAction, cancel.onAction, vc.onDismiss])
                .ignoreElements()
                .subscribe(onCompleted: {
                    print("On Complete")
                })
                .disposed(by: disposeBag)
            
            self.present(vc, animated: false)
        }))
        
        actions.append(Example(text: "No actions, no description", action: { //[weak self] in
        }))
        actions.append(Example(text: "No actions, with description", action: { //[weak self] in
        }))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(backgroundView)
        view.addSubview(tableView)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundView.frame = view.bounds
    }

}


extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? alerts.count : actions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as! TableViewCell
        switch indexPath.section {
        case 0:
            cell.title = alerts[indexPath.row].text
        case 1:
            cell.title = actions[indexPath.row].text
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Alert" : "Action Sheet"
    }
}


extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            switch indexPath.section {
            case 0:
                self.alerts[indexPath.row].action()
            case 1:
                self.actions[indexPath.row].action()
            default:
                break
            }
        }
    }
}
