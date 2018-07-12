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
