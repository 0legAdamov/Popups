//
//  PopupActionSheetController.swift
//  
//
//  Created by Oleg Adamov on 20.12.2020.
//

import UIKit


class PopupActionSheetController: PopupController {
    
    var animator: UIViewPropertyAnimator?
    
    var actionSheetView: PopupActionSheetView!
    
    private let actionSheetModel: PopupActionSheet
    
    override var modalIntaraction: Bool {
        return actionSheetModel.modalInteraction
    }
    
    
    init(model: PopupActionSheet) {
        self.actionSheetModel = model
        super.init()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assert(actionSheetModel.isValid)
        
        var maxWidth = min(view.bounds.width, view.bounds.height) - 2 * xPadding
        maxWidth = min(500, maxWidth)
        actionSheetView = PopupActionSheetView(model: actionSheetModel, inWidth: maxWidth)
        actionSheetView.frame.origin = CGPoint(x: round((view.bounds.width - actionSheetView.bounds.width) / 2), y: view.bounds.height + 20)
        view.addSubview(actionSheetView)
        
        actionSheetView.hideAction = { [weak self] in
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
        
        guard animator != nil else { return }
        actionSheetView.frame.origin = CGPoint(x: round((view.bounds.width - actionSheetView.bounds.width) / 2), y: actionSheetEndY())
    }
    
    
    override func pointIsOutside(withGesture gesture: UITapGestureRecognizer) -> Bool {
        let point = gesture.location(in: view)
        return !actionSheetView.frame.contains(point)
    }
    
    
    //MARK: - Hide & Show
    
    private func actionSheetEndY() -> CGFloat {
        return view.bounds.height - actionSheetView.bounds.height - max(view.safeAreaInsets.bottom + 4, 20)
    }
    
    private func showAnimated() {
        if let animator = self.animator, animator.state != .inactive {
            animator.stopAnimation(true)
        }
        
        let origin = CGPoint(x: round((view.bounds.width - actionSheetView.bounds.width) / 2), y: actionSheetEndY())
        animator = UIViewPropertyAnimator(duration: 0.4, dampingRatio: 0.6) {
            self.darkView.alpha = 1
            self.actionSheetView.frame.origin = origin
        }
        animator?.startAnimation()
    }
    
    
    override func hideAnimated() {
        if let animator = self.animator, animator.state != .inactive {
            animator.stopAnimation(true)
        }
        
        let origin = CGPoint(x: round((view.bounds.width - actionSheetView.bounds.width) / 2), y: view.bounds.height + 20)
        animator = UIViewPropertyAnimator(duration: 0.4, dampingRatio: 0.6) {
            self.darkView.alpha = 0
            self.actionSheetView.frame.origin = origin
        }
        animator?.addCompletion { _ in
            self.dismiss(animated: false) {
                self.actionSheetModel.dismissSubject.onNext(())
                self.actionSheetModel.dismissSubject.onCompleted()
            }
        }
        animator?.startAnimation()
    }
}
