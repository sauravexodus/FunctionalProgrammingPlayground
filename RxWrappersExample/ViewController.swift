//
//  ViewController.swift
//  RxWrappersExample
//
//  Created by Sourav Chandra on 12/07/18.
//  Copyright © 2018 Sourav Chandra. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import RxSwift
import RxCocoa

protocol ViewControllerDelegate: class {
    func sampleMethod1()
    func sampleMethod2()
}

class ViewController: UIViewController {

    let disposeBag = DisposeBag()
    weak var delegate: ViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    

}

