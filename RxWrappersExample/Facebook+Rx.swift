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

extension Reactive where Base: GraphRequestProtocol {
    func start() -> Observable<(HTTPURLResponse?, GraphRequestResult<Base>)> {
        return Observable.create { observer in
            self.base.start { (urlReponse, result) in
                observer.onNext((urlReponse, result))
            }
            return Disposables.create()
        }
    }
}

extension GraphRequest: ReactiveCompatible {}
