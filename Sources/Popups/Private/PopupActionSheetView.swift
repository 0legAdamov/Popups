//
//  PopupActionSheetView.swift
//  
//
//  Created by Oleg Adamov on 20.12.2020.
//

import UIKit
import RxSwift


class PopupActionSheetView: PopupView {
    
    private let model: PopupActionSheet
    
    private let disposeBag = DisposeBag()
    
    
    init(model: PopupActionSheet, inWidth width: CGFloat) {
        self.model = model
        let frame = CGRect(x: 0, y: 0, width: width, height: 0)
        super.init(frame: frame)
        
        var lastY = contentInsets.top
        
        let container = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 0))
        container.applyPopupStyle()
        
        if let title = model.title {
            let titleLabel = makeTitle(text: title)
            lastY = titleLabel.frame.maxY
            container.addSubview(titleLabel)
        }
        
        if let subtitle = model.subtitle {
            let subtitleLabel = makeSubtitle(text: subtitle, y: lastY)
            lastY = subtitleLabel.frame.maxY
            container.addSubview(subtitleLabel)
        }
        lastY += contentInsets.top
        
        if !model.buttons.isEmpty {
            let frames = framesWithVerticalLayout(y: lastY, count: model.buttons.count)
            frames.separators.forEach {
                container.addSubview(makeLine(frame: $0))
            }
            frames.buttons.enumerated().forEach {
                container.addSubview(makeButton(index: $0.offset, frame: $0.element))
            }
            lastY = frames.buttons.last!.maxY
        }
        
        container.frame.size.height = lastY
        addSubview(container)
        lastY += 12
        
        let cancelContainer = UIView(frame: CGRect(x: 0, y: lastY, width: width, height: PopupButtonView.preferredHeight))
        cancelContainer.applyPopupStyle()
        cancelContainer.addSubview(makeCancelButton(frame: cancelContainer.bounds))
        lastY = cancelContainer.frame.maxY
        addSubview(cancelContainer)
        
        self.frame.size.height = lastY + contentInsets.bottom
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func makeCancelButton(frame: CGRect) -> PopupButtonView {
        let buttonModel = PopupButton(title: model.cancelButtonTitle ?? "")
        let button = PopupButtonView(frame: frame, model: buttonModel, index: model.buttons.count)
        
        button.rx.tap
            .subscribe { [weak self] _ in
                self?.hideAction?()
                self?.model.cancelSubject.onNext(())
                self?.model.cancelSubject.onCompleted()
            }.disposed(by: disposeBag)
        
        return button
    }
    
    
    private func makeButton(index: Int, frame: CGRect) -> PopupButtonView {
        let buttonModel = model.buttons[index]
        let button = PopupButtonView(frame: frame, model: buttonModel, index: index)
        
        button.rx.tap
            .subscribe { [weak self] _ in
                self?.hideAction?()
                guard let model = self?.model.buttons[index] else { return }
                model.actionSubject.onNext(())
                model.actionSubject.onCompleted()
            }.disposed(by: disposeBag)
        
        return button
    }
}
