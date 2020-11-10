import UIKit
import RxCocoa
import RxSwift


typealias ButtonAndLinesFrames = (buttons: [CGRect], separators: [CGRect])


class PopupAlertView: PopupView {
    
    private let textFieldHeight: CGFloat = 21
    
    private let alertModel: PopupAlert
    private(set) var textField: UITextField?
    private let disposeBag = DisposeBag()
    
    
    init(model: PopupAlert, inWidth width: CGFloat) {
        self.alertModel = model
        let frame = CGRect(x: 0, y: 0, width: width, height: 0)
        super.init(frame: frame)
        
        applyPopupStyle()
        
        var lastY = contentInsets.top
        
        if let title = model.title {
            let titleLabel = makeTitle(text: title)
            lastY = titleLabel.frame.maxY
            addSubview(titleLabel)
        }
        
        if let subtitle = model.subtitle {
            let subtitleLabel = makeSubtitle(text: subtitle, y: lastY)
            lastY = subtitleLabel.frame.maxY
            addSubview(subtitleLabel)
        }
        
        if let textFieldModel = model.textField {
            var textfieldX = contentInsets.left
            
            if let icon = textFieldModel.image {
                let iconView = makeTextFieldIcon(image: icon, y: lastY + 20)
                textfieldX = iconView.frame.maxX + 7
                addSubview(iconView)
            }
            
            textField = makeTextField(model: textFieldModel, x: textfieldX, y: lastY + 20)
            lastY = textField!.frame.maxY
            addSubview(textField!)
        }
        
        lastY = textField != nil ? lastY + 20 : lastY + 23
        
        var frames: ButtonAndLinesFrames = ([CGRect](), [CGRect]())
        let maxBtnWidth = model.buttons.map { PopupButtonView.width(for: $0) }.max()!
        let availableWidth = bounds.width - contentInsets.left - contentInsets.right
        let verticalLayout = availableWidth < maxBtnWidth || model.buttons.count != 2
        frames = verticalLayout ? framesWithVerticalLayout(y: lastY) : framesWithHorizontalLayout(y: lastY)
        
        frames.separators.forEach {
            addSubview(makeLine(frame: $0))
        }
        
        frames.buttons.enumerated().forEach {
            addSubview(makeButton(index: $0.offset, frame: $0.element))
        }
        
        self.frame.size.height = frames.buttons.map { $0.maxY }.max()!
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func framesWithVerticalLayout(y: CGFloat) -> ButtonAndLinesFrames {
        var bFrames = [CGRect]()
        var lFrames = [CGRect]()
        var lastY = y
        
        for _ in 0..<alertModel.buttons.count {
            let lWidth = bounds.width - contentInsets.left - contentInsets.right
            let lFrame = CGRect(x: contentInsets.left, y: lastY, width: lWidth, height: 1)
            lastY += 1
            lFrames.append(lFrame)
            
            let bSize = CGSize(width: bounds.width - contentInsets.left - contentInsets.right, height: PopupButtonView.preferredHeight)
            let bFrame = CGRect(x: contentInsets.left, y: lastY , width: bSize.width, height: bSize.height)
            lastY = bFrame.maxY
            bFrames.append(bFrame)
        }
        
        return (bFrames, lFrames)
    }
    
    
    private func framesWithHorizontalLayout(y: CGFloat) -> ButtonAndLinesFrames {
        var bFrames = [CGRect]()
        var lFrames = [CGRect]()
        var lastY = y
        
        let hlWidth = bounds.width - contentInsets.left - contentInsets.right
        let lFrame = CGRect(x: contentInsets.left, y: lastY, width: hlWidth, height: 1)
        lastY += 1
        lFrames.append(lFrame)
        
        let vlFrame = CGRect(x: bounds.width / 2 - 0.5, y: lastY + 5, width: 1, height: PopupButtonView.preferredHeight - 10)
        lFrames.append(vlFrame)
        
        let btnWidth = round((bounds.width - contentInsets.left) / 2) - 1
        bFrames.append(CGRect(x: contentInsets.left, y: lastY, width: btnWidth, height: PopupButtonView.preferredHeight))
        bFrames.append(CGRect(x: bounds.width - contentInsets.right - btnWidth, y: lastY, width: btnWidth, height: PopupButtonView.preferredHeight))
        
        return (bFrames, lFrames)
    }
    
    
    private func makeTextFieldIcon(image: UIImage, y: CGFloat) -> UIImageView {
        var frame = CGRect(x: contentInsets.left, y: y, width: 20, height: 20)
        frame.origin.y += round((textFieldHeight - image.size.height) / 2)
        
        let imView = UIImageView(frame: frame)
        imView.contentMode = .scaleAspectFit
        imView.image = image
        imView.tintColor = PopupConfig.colors.textfieldIcon
        return imView
    }
    
    
    private func makeTextField(model: PopupAlertTextField, x: CGFloat, y: CGFloat) -> UITextField {
        let frame = CGRect(x: x, y: y, width: bounds.width - x - contentInsets.right, height: textFieldHeight)
        let textField = UITextField(frame: frame)
        if let placeholder = model.placeholder {
            textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.font: PopupConfig.fonts.textfield, .foregroundColor: PopupConfig.colors.textfieldPlaceholder])
        }
        textField.borderStyle = .none
        
        // handle text
        textField.rx.text
            .subscribe(onNext: { [weak model] text in
                model?.text = text
            }).disposed(by: disposeBag)
        
        return textField
    }
    
    
    private func makeButton(index: Int, frame: CGRect) -> PopupButtonView {
        let buttonModel = alertModel.buttons[index]
        let button = PopupButtonView(frame: frame, model: buttonModel, index: index)
        
        if let textfield = self.textField, let alertButton = buttonModel as? PopupAlertButton, alertButton.textFieldTracking {
            textfield.rx.text
                .map { !($0?.isEmpty ?? true) }
                .distinctUntilChanged()
                .bind(to: button.rx.enabled)
                .disposed(by: disposeBag)
        }
        
        button.rx.tap
            .subscribe { [weak self] _ in
                self?.hideAction?()
                guard let model = self?.alertModel.buttons[index] else { return }
                model.actionSubject.onNext(())
                model.actionSubject.onCompleted()
            }.disposed(by: disposeBag)

        return button
    }
}
