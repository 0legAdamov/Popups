import UIKit


class PopupAlertController: PopupController {
    
    var animator: UIViewPropertyAnimator?
    
    var alertView: PopupAlertView!
    
    override var modalIntaraction: Bool {
        return alertModel.modalInteraction
    }
    
    private let alertModel: PopupAlert
    
    private var alertWithTextfield: Bool {
        return alertModel.textField != nil
    }
    
    
    init(model: PopupAlert) {
        self.alertModel = model
        super.init()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assert(alertModel.isValid)
        
        alertView = PopupAlertView(model: alertModel, inWidth: min(view.bounds.width, view.bounds.height) - 2 * xPadding)
        alertView.alpha = 0
        alertView.center = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2)
        alertView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        view.addSubview(alertView)
        
        alertView.hideAction = { [weak self] in
            self?.hideAnimated()
        }
        
        if alertWithTextfield {
            NotificationCenter.default.addObserver(self, selector: #selector(willShowKeyboard(_:)), name: UIWindow.keyboardWillShowNotification, object: nil)
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard isFirstAppearance else { return }
        
        if alertWithTextfield {
            alertView.textField?.becomeFirstResponder()
        } else {
            showAnimated()
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !alertWithTextfield {
            alertView.center = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2)
        } // else keyboard will update alert view center
    }
    
    
    override func pointIsOutside(withGesture gesture: UITapGestureRecognizer) -> Bool {
        let point = gesture.location(in: view)
        return !alertView.frame.contains(point)
    }
    
    
    //MARK: - Hide & Show
    
    private func showAnimated(keyboardHeight: CGFloat = 0) {
        if let animator = self.animator, animator.state != .inactive {
            animator.stopAnimation(true)
        }
        
        let center = CGPoint(x: view.bounds.width / 2, y: calculateAlertCenterY(with: keyboardHeight))
        animator = UIViewPropertyAnimator(duration: 0.4, dampingRatio: 0.6) {
            self.darkView.alpha = 1
            self.alertView.alpha = 1
            self.alertView.transform = .identity
            self.alertView.center = center
        }
        animator?.startAnimation()
    }
    
    
    override func hideAnimated() {
        if let animator = self.animator, animator.state != .inactive {
            animator.stopAnimation(true)
        }
        
        alertView.textField?.resignFirstResponder()
        
        let center = CGPoint(x: view.bounds.width / 2, y: alertView.center.y - 2 * alertView.bounds.height)
        animator = UIViewPropertyAnimator(duration: 0.4, dampingRatio: 0.8) {
            self.darkView.alpha = 0
            self.alertView.alpha = 0
            if self.alertWithTextfield {
                self.alertView.center = center
            } else {
                self.alertView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            }
        }
        animator?.addCompletion { _ in
            self.dismiss(animated: false, completion: {
                self.alertModel.dismissSubject.onNext(())
                self.alertModel.dismissSubject.onCompleted()
            })
        }
        animator?.startAnimation()
    }
    
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return alertWithTextfield ? .portrait : super.supportedInterfaceOrientations
    }
    
    
    //MARK: - Keyboard
    
    private func calculateAlertCenterY(with keyboardheight: CGFloat) -> CGFloat {
        if keyboardheight == 0 {
            return view.bounds.height / 2
        }
        let keyboardMinY = view.bounds.height - keyboardheight
        let freeY = (keyboardMinY - alertView.bounds.height) / 2
        let bottomPadding = freeY >= 32 ? 32 : max(freeY, 2)
        return keyboardMinY - bottomPadding - alertView.bounds.height / 2
    }
    
    
    @objc private func willShowKeyboard(_ notification: Notification) {
        guard let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        showAnimated(keyboardHeight: frame.cgRectValue.height)
    }
}
