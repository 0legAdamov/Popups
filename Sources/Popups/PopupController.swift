import UIKit


public class PopupController: UIViewController {
    
    public var onDismiss: (() -> Void)?
    
    var isFirstAppearance: Bool {
        return appearanceCount <= 1
    }

    var modalInteraction: Bool {
        return false
    }
    
    private var appearanceCount: UInt = 0
    
    private lazy var darkView: UIView = {
        let view = UIView(frame: self.view.bounds)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        view.alpha = 0
        return view
    }()
    
    
    init() {
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
        
        self.view.backgroundColor = .clear
        self.view.addSubview(self.darkView)

        if !self.modalInteraction {
            appendOutsideGesture()
        }
    }
    
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appearanceCount += 1
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard self.isFirstAppearance else { return }
        showAnimated()
    }
    
    
    func pointIsOutside(withGesture gesture: UITapGestureRecognizer) -> Bool {
        return true
    }
    
    
    func showAnimated() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.darkView.alpha = 1
        }, completion: nil)
    }
    
    
    func hideAnimated() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.darkView.alpha = 0
        }) { _ in
            self.dismiss(animated: false, completion: { [weak self] in
                self?.onDismiss?()
            })
        }
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
