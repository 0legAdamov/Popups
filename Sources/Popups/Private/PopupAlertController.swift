import UIKit


class PopupAlertController: PopupController {
    
    var animator: UIViewPropertyAnimator?
    
    var alertView: PopupAlertView!
    
    override var modalIntaraction: Bool {
        return alertModel.modalInteraction
    }
    
    private let alertModel: PopupAlert
    
    
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
        
        alertView = PopupAlertView(model: alertModel, inWidth: view.bounds.width - 2 * xPadding)
        alertView.alpha = 0
        alertView.center = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2)
        alertView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        view.addSubview(alertView)
        
        alertView.hideAction = { [weak self] in
            self?.hideAnimated()
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard isFirstAppearance else { return }
        
        showAnimated()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        alertView.center = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2)
    }
    
    
    override func pointIsOutside(withGesture gesture: UITapGestureRecognizer) -> Bool {
        let point = gesture.location(in: view)
        return !alertView.frame.contains(point)
    }
    
    
    //MARK: - Hide & Show
    
    private func showAnimated() {
        if let animator = self.animator, animator.state != .inactive {
            animator.stopAnimation(true)
        }
        
        animator = UIViewPropertyAnimator(duration: 0.4, dampingRatio: 0.6) {
            self.darkView.alpha = 1
            self.alertView.alpha = 1
            self.alertView.transform = .identity
            self.alertView.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2)
        }
        animator?.startAnimation()
    }
    
    
    override func hideAnimated() {
        if let animator = self.animator, animator.state != .inactive {
            animator.stopAnimation(true)
        }
        
        animator = UIViewPropertyAnimator(duration: 0.4, dampingRatio: 0.8) { //.. temp 0.4
            self.darkView.alpha = 0
            self.alertView.alpha = 0
            self.alertView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        }
        animator?.addCompletion { _ in
            self.dismiss(animated: false, completion: {
                self.alertModel.dismissSubject.onNext(())
                self.alertModel.dismissSubject.onCompleted()
            })
        }
        animator?.startAnimation()
    }
    
    
    //MARK: - Keyboard
    
//    @objc private func willShowKeyboard(_ notification: Notification) {
//        guard let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
//        let keyboardHeight = frame.cgRectValue.height
//        lastKeyboardHeight = keyboardHeight
//        view.setNeedsLayout()
//    }
}
