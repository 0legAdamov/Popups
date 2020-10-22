import UIKit


typealias ButtonAndLinesFrames = (buttons: [CGRect], separators: [CGRect])


class PopupAlertView: PopupView {
    
    private let textFieldHeight: CGFloat = 21
    
    private let alertModel: PopupAlert
    private(set) var textField: UITextField?
    
    
    init(model: PopupAlert, inWidth width: CGFloat) {
        self.alertModel = model
        let frame = CGRect(x: 0, y: 0, width: width, height: 0)
        super.init(frame: frame)
        
        self.applyPopupStyle()
        
        var lastY: CGFloat = contentInsets.top
        
        if let title = model.title {
            let titleLabel = makeTitle(text: title)
            lastY = titleLabel.frame.maxY
            addSubview(titleLabel)
        }
        
        if let subtitle = model.subTitle {
            let subtitleLabel = makeSubtitle(text: subtitle, lastContentY: lastY)
            lastY = subtitleLabel.frame.maxY
            addSubview(subtitleLabel)
        }
        
        if let textFieldModel = model.textField {
            var textfieldX = contentInsets.left
            
            if let icon = textFieldModel.image {
                let iconView = makeTextFieldIcon(image: icon, y: lastY + 18)
                self.addSubview(iconView)
                
                textfieldX = iconView.frame.maxX + 12
            }
            
            self.textField = makeTextField(model: textFieldModel, x: textfieldX, y: lastY + 18)
            lastY = self.textField!.frame.maxY
            self.addSubview(self.textField!)
        }
        
        lastY = textField != nil ? lastY + 17 : lastY + 14
        
        let hlFrame = CGRect(x: contentInsets.left, y: lastY, width: bounds.width - contentInsets.left - contentInsets.right, height: 1)
        let hLine = makeLine(frame: hlFrame)
        self.addSubview(hLine)
        lastY += hlFrame.height
        
        let buttonsYPadding = (model.buttons.count == 1 && model.buttons[0].style != .bordless) ? 20 : contentInsets.bottom
        let buttonsY = lastY + buttonsYPadding
        
        var frames: ButtonAndLinesFrames = ([CGRect](), [CGRect]())
        if model.buttons.count == 2 {
            let availableWidth = round(self.bounds.width / 2) - 30
            let maxWidth = model.buttons.map { PopupActionButton.width(for: $0) }.max()!
            frames = availableWidth < maxWidth ? framesWithVerticalLayout(y: buttonsY) : framesWithHorizontalLayout(y: buttonsY)
        } else {
            frames = framesWithVerticalLayout(y: buttonsY)
        }
        
        frames.separators.forEach {
            self.addSubview(self.makeLine(frame: $0))
        }
        
        frames.buttons.enumerated().forEach {
            self.addSubview(self.makeButton(index: $0.offset, frame: $0.element))
        }
        
        self.frame.size.height = frames.buttons.map { $0.maxY }.max()! + buttonsYPadding
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func framesWithVerticalLayout(y: CGFloat) -> ButtonAndLinesFrames {
        var bFrames = [CGRect]()
        var lines = [CGRect]()
        var lastY = y
        
        let buttons = Array(self.alertModel.buttons.reversed())
        
        for i in 0..<self.alertModel.buttons.count {
            var size = PopupActionButton.preferredSize
            size.width = self.bounds.width - 30
            if buttons[i].style != .bordless {
                size.width = PopupActionButton.width(for: buttons[i]) + size.height
            }
            let bFrame = CGRect(x: round((self.bounds.width - size.width) / 2), y: lastY , width: size.width, height: size.height)
            lastY = bFrame.maxY + 2 * contentInsets.bottom
            bFrames.append(bFrame)
            
            if i > 0 {
                let lWidth = self.bounds.width - contentInsets.left - contentInsets.right
                let lFrame = CGRect(x: contentInsets.left, y: bFrame.minY - contentInsets.bottom, width: lWidth, height: 1)
                lines.append(lFrame)
            }
        }
        
        return (bFrames.reversed(), lines)
    }
    
    
    private func framesWithHorizontalLayout(y: CGFloat) -> ButtonAndLinesFrames {
        var btns = [CGRect]()
        let xPadding: CGFloat = 15
        var btnSize = PopupActionButton.preferredSize
        btnSize.width = round(bounds.width / 2) - 30
        btns.append(CGRect(x: xPadding, y: y, width: btnSize.width, height: btnSize.height))
        btns.append(CGRect(x: round(bounds.width / 2) + xPadding, y: y, width: btnSize.width, height: btnSize.height))
        
        let vlFrame = CGRect(x: bounds.width / 2 - 0.5, y: y, width: 1, height: btnSize.height)
        return (btns, [vlFrame])
    }
    
    
    private func makeTextFieldIcon(image: UIImage, y: CGFloat) -> UIImageView {
        var frame = CGRect(x: contentInsets.left, y: y, width: image.size.width, height: image.size.height)
        frame.origin.y += round((textFieldHeight - image.size.height) / 2)
        
        let imView = UIImageView(frame: frame)
        imView.contentMode = .scaleAspectFit
        imView.image = image
        imView.tintColor = PopupConfig.colors.textfieldIcon
        return imView
    }
    
    
    private func makeTextField(model: PopupAlertTextField, x: CGFloat, y: CGFloat) -> UITextField {
        let frame = CGRect(x: x, y: y, width: self.bounds.width - x - contentInsets.right, height: textFieldHeight)
        
        let textField = UITextField(frame: frame)
        if let placeholder = model.placeholder {
            textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.font: PopupConfig.fonts.textfield, .foregroundColor: PopupConfig.colors.textfieldPlaceholder])
        }
        textField.borderStyle = .none
        
        //.. handle text
        /*textField.rx.text
            .subscribe(onNext: { [weak model] text in
                model?.text = text
            }).disposed(by: disposeBag)
        */
        
        return textField
    }
    
    
    private func makeButton(index: Int, frame: CGRect) -> PopupActionButton {
        let buttonModel = self.alertModel.buttons[index]
        let button = PopupActionButton(frame: frame, style: buttonModel.style, visible: true)
        button.tag = index
        button.text = buttonModel.title
        button.liteFont = !buttonModel.boldTitle
        button.destructive = buttonModel.destructive
        button.highlighted = buttonModel.highlighted
        
        /*if buttonModel.textFieldTracking, let textfield = self.textField {
            textfield.rx.text
                .map { !($0?.isEmpty ?? true) }
                .distinctUntilChanged()
                .bind(to: button.rx.enabled)
                .disposed(by: disposeBag)
        }*/
        //.. track button enable
        
        button.addTarget(target: self, action: #selector(buttonAction(_:)))
        return button
    }
    
    
    @objc private func buttonAction(_ sender: PopupActionButton) {
        hideAction?()
        alertModel.buttons[sender.tag].onAction?()
    }
}
