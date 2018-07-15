//
//  Examples.swift
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

final class Examples {
    private let disposeBag = DisposeBag()
    private let clickableView = ClickableView()
    
    init() { clickableView.delegate = self }
}

// MARK: Bad Implementation

extension Examples: ClickableViewDelegate {
    
    func updateUserProfileBad() {
        LoginManager().logIn(readPermissions: [.email]) { (loginResult) in
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
    
    func onTap() {
        updateUserProfileBad()
    }
    
}

// MARK: Good Implementation

extension Examples {
    
    func updateUserProfileGood() {
        clickableView.rx.onButtonTapped
            .flatMapLatest { _ in  LoginManager().rx.logIn(readPermissions: [.email]) }
            .flatMapLatest { _ in GraphRequest(graphPath: "me").rx.start() }
            .flatMapLatest { ApiRequest.updateProfile(profileData: $0).rx.makeRequest() }
            .catchError { error in .just("Some error occured") }
            .subscribe(onNext: { _ in
                print("Success!")
            })
            .disposed(by: disposeBag)
    }
    
}


