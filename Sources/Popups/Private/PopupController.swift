import UIKit
import RxSwift
import RxCocoa


class PopupController: UIViewController {
    
    let xPadding: CGFloat = 26
    
    var isFirstAppearance: Bool {
        return appearanceCount <= 1
    }
    
    var modalIntaraction: Bool {
        assertionFailure("Need implement in subclass")
        return false
    }
    
    lazy var darkView: UIVisualEffectView = {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        view.alpha = 0
        return view
    }()
    
    private var appearanceCount: UInt = 0
    
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overFullScreen
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        view.addSubview(darkView)

        if !modalIntaraction {
            appendOutsideGesture()
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appearanceCount += 1
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        darkView.frame = view.bounds
    }
    
    
    func pointIsOutside(withGesture gesture: UITapGestureRecognizer) -> Bool {
        assertionFailure("Need implement in subclass")
        return true
    }
    
    
    func hideAnimated() {
        assertionFailure("Need implement in subclass")
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
    
}
