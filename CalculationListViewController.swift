//
//  CalculationListViewController.swift
//  Tinkoff Calculator
//
//  Created by Данис Байрамгулов on 26.05.2025.
//

import UIKit

class CalculCalculationListViewController: UIViewController {

    var result: String?

    @IBOutlet weak var calculationLable: UILabel!

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        initialize()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }

    private func initialize() {
        modalPresentationStyle = .automatic
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        calculationLable.text = result
    }

    @IBAction func dismissVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
