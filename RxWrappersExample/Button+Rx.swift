//
//  ButtonDelegate+Rx.swift
//  RxWrappersExample
//
//  Created by Sourav Chandra on 12/07/18.
//  Copyright © 2018 Sourav Chandra. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension ClickableView: HasDelegate {
    public typealias Delegate = ClickableViewDelegate
}

final class ButtonDelegateProxy: DelegateProxy<ClickableView, ClickableViewDelegate>, DelegateProxyType, ClickableViewDelegate {
    static func registerKnownImplementations() {
        self.register { ButtonDelegateProxy(button: $0) }
    }
    
    func onTap() {
        onButtonTapBehaviorSubject.onNext(())
    }
    
    weak private(set) var button: ClickableView?
    
    init(button: ParentObject) {
        self.button = button
        super.init(parentObject: button, delegateProxy: ButtonDelegateProxy.self)
    }
    
    fileprivate var _onButtonTapBehaviorSubject: BehaviorSubject<Void>?
    
    var onButtonTapBehaviorSubject: BehaviorSubject<Void> {
        if let subject = _onButtonTapBehaviorSubject {
            return subject
        }
        let subject = BehaviorSubject(value: ())
        _onButtonTapBehaviorSubject = subject
        return subject
    }
}

extension Reactive where Base: ClickableView {
    var delegateProxy: DelegateProxy<ClickableView, ClickableViewDelegate> {
        return ButtonDelegateProxy(button: base)
    }
    
    var onButtonTapped: ControlEvent<Void> {
        return ControlEvent(events: ButtonDelegateProxy.proxy(for: base).onButtonTapBehaviorSubject) 
    }
}
