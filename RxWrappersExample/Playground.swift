//
//  Playground.swift
//  RxWrappersExample
//
//  Created by Sourav Chandra on 14/07/18.
//  Copyright © 2018 Sourav Chandra. All rights reserved.
//

import Foundation
import RxSwift
import FacebookLogin
import FacebookCore


extension Reactive where Base: LoginManager {
    func logIn(publishPermissions: [PublishPermission], viewController: UIViewController?) -> Observable<LoginResult> {
        return Observable.create { observer in
            self.base.logIn(publishPermissions: publishPermissions, viewController: viewController) { (loginResult) in
                observer.onNext(loginResult)
            }
            return Disposables.create()
        }
    }
}
