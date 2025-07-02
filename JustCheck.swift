//
//  JustCheck.swift
//  Tinkoff Calculator
//
//  Created by Данис Байрамгулов on 25.06.2025.
//

import UIKit

class JustCheckSegwei: UIViewController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    private func initialize(){
        modalPresentationStyle = .fullScreen
    }
}
