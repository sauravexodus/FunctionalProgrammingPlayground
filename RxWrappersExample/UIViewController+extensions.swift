//
//  UIViewController+extensions.swift
//  RxWrappersExample
//
//  Created by Sourav Chandra on 13/07/18.
//  Copyright © 2018 Sourav Chandra. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

extension Reactive where Base: UIViewController {

    var viewDidLoad: ControlEvent<Void> {
        return ControlEvent(events: self.methodInvoked(#selector(base.viewDidLoad)).map { _ in () })
    }

}
