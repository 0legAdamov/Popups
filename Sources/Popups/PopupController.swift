import UIKit


public class PopupController: UIViewController {
    
    public var onDismiss: (() -> Void)?
    
    private var appearanceCount: UInt = 0
    private var animator: UIViewPropertyAnimator?
    private let xPadding: CGFloat = 26
    private let model: PopupModel
    private var modelView: PopupView!
    
    private var isFirstAppearance: Bool {
        return appearanceCount <= 1
    }
    
    private lazy var darkView: UIVisualEffectView = {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        view.alpha = 0
        return view
    }()
    
    
    public init(model: PopupModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overFullScreen
        
        print("!! init", String(describing: type(of: self)))
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    deinit {
        print("!! deinit", String(describing: type(of: self)))
    }
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        view.addSubview(darkView)

        if !model.modalInteraction {
            appendOutsideGesture()
        }
        
        if let alert = model as? PopupAlert {
            modelView = PopupAlertView(model: alert, inWidth: view.bounds.width - 2 * xPadding)
            modelView.center = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2)
            modelView.alpha = 0
            view.addSubview(modelView)
            modelView.hideAction = { [weak self] in
                self?.hideAnimated()
            }
        } else {
            assert(false)
        }
    }
    
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appearanceCount += 1
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard isFirstAppearance else { return }
        showAnimated()
    }
    
    
    func pointIsOutside(withGesture gesture: UITapGestureRecognizer) -> Bool {
        return true
    }
    
    
    func showAnimated() {
        if let animator = self.animator, animator.state != .inactive { return }
        
        self.modelView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        self.animator = UIViewPropertyAnimator(duration: 0.4, dampingRatio: 0.6) {
            self.darkView.alpha = 1
            self.modelView.alpha = 1
            self.modelView.transform = .identity
        }
        self.animator?.startAnimation()
    }
    
    
    func hideAnimated() {
        if let animator = self.animator, animator.state != .inactive {
            animator.stopAnimation(true)
        }
        
        self.animator = UIViewPropertyAnimator(duration: 0.4, dampingRatio: 0.8) {
            self.modelView.alpha = 0
            self.modelView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            self.darkView.alpha = 0
        }
        self.animator?.addCompletion { _ in
            self.dismiss(animated: false, completion: {
                self.onDismiss?()
            })
        }
        self.animator?.startAnimation()
    }


    private func appendOutsideGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        guard pointIsOutside(withGesture: gesture) else { return }
        view.removeGestureRecognizer(gesture)
        hideAnimated()
    }
    
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        darkView.frame = view.bounds
    }
}
