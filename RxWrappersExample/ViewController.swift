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

class ViewController: UIViewController {

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func updateUserProfileGood() {
        LoginManager().rx.logIn(readPermissions: [.email])
            .flatMapLatest { _ in GraphRequest(graphPath: "me").rx.start() }
            .map { response -> [String: Any]? in
                guard case let .success(data) = response.1 else { return nil }
                return data.dictionaryValue
            }
            .unwrap()
            .map { $0! }
            .flatMapLatest { ApiRequest.updateProfile(profileData: $0).rx.makeRequest() }
            .catchError { error in .just("Some error occured") }
            .subscribe(onNext: { _ in
                print("Success!")
            })
            .disposed(by: disposeBag)
        
    }

    private func updateUserProfileBad() {
        LoginManager().logIn(readPermissions: [.email], viewController: self) { (loginResult) in
            GraphRequest(graphPath: "/me").start({ (urlResponse, result) in
                if case let .success(data) = result, let profileData = data.dictionaryValue {
                    ApiRequest.updateProfile(profileData: profileData).makeRequest({ (data, urlResponse, error) in
                        if error != nil {
                            print("Success!")
                        }
                        print("Api error")
                    })
                }
                print("Something went wrong!")
            })
        }
    }
    
}





