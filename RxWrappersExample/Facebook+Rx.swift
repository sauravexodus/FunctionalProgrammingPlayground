//
//  Facebook+Rx.swift
//  RxWrappersExample
//
//  Created by Sourav Chandra on 12/07/18.
//  Copyright © 2018 Sourav Chandra. All rights reserved.
//

import Foundation
import FacebookCore
import FacebookLogin
import RxSwift
import AccountKit
import RxCocoa

extension Reactive where Base: LoginManager {
    func logIn(readPermissions: [ReadPermission], viewController: UIViewController? = nil) -> Observable<LoginResult> {
        return Observable.create { observer in
            self.base.logIn(readPermissions: readPermissions, viewController: viewController, completion: { loginResult in
                observer.onNext(loginResult)
            })
            return Disposables.create()
        }
    }
}

extension LoginManager: ReactiveCompatible {}

extension Reactive where Base: GraphRequestProtocol, Base.Response == GraphResponse {
    func start() -> Observable<[String: Any]> {
        return Observable.create { observer in
            self.base.start { (urlReponse, result) in
                guard case let .success(data) = result, let value = data.dictionaryValue else {
                    observer.onError(NSError(
                        domain:  "com.facebook.graphrequest",
                        code: 1,
                        userInfo: [NSLocalizedDescriptionKey: "Could not parse the data"]
                    ))
                    return
                }
                observer.onNext(value)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
}

extension GraphRequest: ReactiveCompatible {}

final class AKFViewControllerDelegateProxy: DelegateProxy<AKFViewController, AKFViewControllerDelegate>, DelegateProxyType, AKFViewControllerDelegate {
    
    weak private(set) var viewController: AKFViewController?
    
    init(_ viewController: AKFViewController) {
        self.viewController = viewController
        super.init(parentObject: viewController, delegateProxy: AKFViewControllerDelegateProxy.self)
    }
    
    static func registerKnownImplementations() {
        self.register { AKFViewControllerDelegateProxy($0) }
    }
    
    static func currentDelegate(for object: AKFViewController) -> AKFViewControllerDelegate? {
        return object.delegate
    }
    
    static func setCurrentDelegate(_ delegate: AKFViewControllerDelegate?, to object: AKFViewController) {
        object.delegate = delegate
    }
    
    // MARK: Implementations
    
    fileprivate var _accessToken: Observable<AKFAccessToken>?
    
    internal var accessToken: Observable<AKFAccessToken> {
        if let accessToken = _accessToken {
            return accessToken
        }
        let accessToken = self.methodInvoked(#selector(viewController(_:didCompleteLoginWith:state:))).map { $0[2] as! AKFAccessToken }
        _accessToken = accessToken
        return accessToken
    }
    
    func viewController(_ viewController: (UIViewController & AKFViewController)!, didFailWithError error: Error!) {}
    
    func viewController(_ viewController: (UIViewController & AKFViewController)!, didCompleteLoginWith accessToken: AKFAccessToken!, state: String!) {}
}

extension Reactive where Base: AKFViewController & UIViewController {
    
    var delegateProxy: DelegateProxy<AKFViewController, AKFViewControllerDelegate> {
        return AKFViewControllerDelegateProxy(base)
    }
    
    var onButtonTapped: ControlEvent<AKFAccessToken> {
        return ControlEvent(events: AKFViewControllerDelegateProxy.proxy(for: base).accessToken)
    }

}

extension AKFViewController where Self: UIViewController {
    
}
