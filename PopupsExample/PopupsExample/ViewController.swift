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
            
            let done = PopupAlertButton(title: "Done")
            done.onAction
                .subscribe(onNext: { _ in
                    print("btn: next")
                })
                .disposed(by: disposeBag)
            alert.append(button: done)
            
            Observable.combineLatest([done.onAction, alert.onDismiss])
                .ignoreElements()
                .subscribe(onCompleted: {
                    print("Complete and Hide")
                })
                .disposed(by: disposeBag)
            
            alert.show(on: self)
        }))
        
        alerts.append(Example(text: "With Description", action: { [unowned self] in
            let alert = PopupAlert(title: "Modal Alert", subtitle: "Alert modal interaction. Some example description for alert view demo in two strings")
            alert.modalInteraction = true
            
            let done = PopupAlertButton(title: "Done")
            alert.append(button: done)
            
            alert.show(on: self)
        }))
        
        alerts.append(Example(text: "Two actions", action: { [unowned self] in
            let alert = PopupAlert(title: "Alert without description")
            
            let done = PopupAlertButton(title: "Remove")
            done.destructive = true
            alert.append(button: done)
            
            let cancel = PopupAlertButton(title: "Cancel")
            cancel.boldTitle = true
            alert.append(button: cancel)
            
            alert.show(on: self)
        }))
        
        alerts.append(Example(text: "Three actions", action: { [unowned self] in
            let alert = PopupAlert(title: "Alert without description")
            
            let action = PopupAlertButton(title: "Action")
            alert.append(button: action)
            
            let remove = PopupAlertButton(title: "Remove")
            remove.destructive = true
            alert.append(button: remove)
            
            let cancel = PopupAlertButton(title: "Cancel")
            cancel.boldTitle = true
            alert.append(button: cancel)
            
            Observable.combineLatest([action.onAction, remove.onAction, cancel.onAction, alert.onDismiss])
                .ignoreElements()
                .subscribe(onCompleted: {
                    print("Complete adn Hide")
                })
                .disposed(by: disposeBag)
            
            alert.show(on: self)
        }))
        
        alerts.append(Example(text: "Alert with textfield", action: { [unowned self] in
            let alert = PopupAlert(title: "Alert with textfield", subtitle: "Whether the button is enabled depends on whether there is text in the textfield")
            alert.textField = PopupAlertTextField(placeholder: "Input here...", text: nil, image: nil)
            
            let cancel = PopupButton(title: "Cancel")
            cancel.boldTitle = true
            alert.append(button: cancel)
            
            let apply = PopupAlertButton(title: "Apply")
            apply.textFieldTracking = true
            apply.trackingRule = { text in
                return !(text ?? "").isEmpty
            }
            alert.append(button: apply)
            
            alert.onDismiss
                .ignoreElements()
                .subscribe(onCompleted: {
                    print("on completed")
                }, onDisposed: {
                    print("on disposed")
                })
                .disposed(by: disposeBag)
            
            alert.show(on: self)
        }))
        
        alerts.append(Example(text: "Alert with textfield and icon", action: { [unowned self] in
            let alert = PopupAlert(title: "Alert with textfield", subtitle: "Whether the button is enabled depends on whether there is text in the textfield")
            alert.textField = PopupAlertTextField(placeholder: "Input here...", text: nil, image: UIImage(systemName: "person.crop.circle"))
            
            let cancel = PopupButton(title: "Cancel")
            cancel.boldTitle = true
            alert.append(button: cancel)
            
            let apply = PopupAlertButton(title: "Apply")
            apply.textFieldTracking = true
            alert.append(button: apply)
            
            alert.onDismiss
                .ignoreElements()
                .subscribe(onCompleted: {
                    print("on completed")
                }, onDisposed: {
                    print("on disposed")
                })
                .disposed(by: disposeBag)
            
            alert.show(on: self)
        }))
        
        // action sheets
        
        actions.append(Example(text: "No actions, no description", action: { [unowned self] in
            let actionSheet = PopupActionSheet(title: "No actions, no description", cancelButtonTitle: "Cancel")
            
            actionSheet.onDismiss
                .ignoreElements()
                .subscribe(onCompleted: {
                    print("on completed")
                })
                .disposed(by: disposeBag)
            
            actionSheet.show(on: self)
        }))
        
        actions.append(Example(text: "No actions, with description", action: { [unowned self] in
            let actionSheet = PopupActionSheet(title: "No actions", subtitle: "Some long description of action sheet view", cancelButtonTitle: "Cancel")
            
            actionSheet.onDismiss
                .ignoreElements()
                .subscribe(onCompleted: {
                    print("Hide")
                })
                .disposed(by: disposeBag)
            
            Observable.combineLatest([actionSheet.onCancel, actionSheet.onDismiss])
                .ignoreElements()
                .subscribe(onCompleted: {
                    print("Cancel and Hide")
                })
                .disposed(by: disposeBag)
            
            actionSheet.show(on: self)
        }))
        
        actions.append(Example(text: "One action", action: { [unowned self] in
            let actionSheet = PopupActionSheet(title: "Some Title", subtitle: "Some long description of action sheet view", cancelButtonTitle: "Cancel")
            
            let action = PopupButton(title: "Some Action")
            actionSheet.append(button: action)
            
            action.onAction
                .subscribe(onNext: { _ in
                    print("btn: next")
                })
                .disposed(by: disposeBag)
            
            Observable.combineLatest([action.onAction, actionSheet.onDismiss])
                .ignoreElements()
                .subscribe(onCompleted: {
                    print("Action and Hide")
                })
                .disposed(by: disposeBag)
            
            actionSheet.show(on: self)
        }))
        
        actions.append(Example(text: "Three actions", action: { [unowned self] in
            let actionSheet = PopupActionSheet(title: "Some Title", cancelButtonTitle: "Cancel")
            
            let action1 = PopupButton(title: "First Action")
            actionSheet.append(button: action1)
            action1.onAction
                .subscribe(onNext: { _ in
                    print("btn 1: next")
                })
                .disposed(by: disposeBag)
            
            let action2 = PopupButton(title: "Delete Action")
            action2.destructive = true
            actionSheet.append(button: action2)
            action2.onAction
                .subscribe(onNext: { _ in
                    print("btn 2: next")
                })
                .disposed(by: disposeBag)
            
            let action3 = PopupButton(title: "Third Action")
            actionSheet.append(button: action3)
            action3.onAction
                .subscribe(onNext: { _ in
                    print("btn 3: next")
                })
                .disposed(by: disposeBag)
            
            actionSheet.show(on: self)
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
