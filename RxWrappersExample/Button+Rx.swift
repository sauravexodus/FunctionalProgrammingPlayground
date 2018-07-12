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

extension Button: HasDelegate {
    public typealias Delegate = ButtonDelegate
}

final class ButtonDelegateProxy: DelegateProxy<Button, ButtonDelegate>, DelegateProxyType, ButtonDelegate {
    static func registerKnownImplementations() {
        self.register { ButtonDelegateProxy(button: $0) }
    }
    
    func onButtonTapped() {
        onButtonTapBehaviorSubject.onNext(())
    }
    
    weak private(set) var button: Button?
    
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

extension Reactive where Base: Button {
    var delegateProxy: DelegateProxy<Button, ButtonDelegate> {
        return ButtonDelegateProxy(button: base)
    }
    
    var onButtonTapped: ControlEvent<Void> {
        return ControlEvent(events: ButtonDelegateProxy.proxy(for: base).onButtonTapBehaviorSubject) 
    }
}
