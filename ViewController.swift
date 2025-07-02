//
//  ViewController.swift
//  Tinkoff Calculator
//
//  Created by Данис Байрамгулов on 22.04.2025.
//

import UIKit

enum CalculatorErrors: Error {
    case divisionByZero
}

enum Operation: String {
    case add = "+"
    case subtract = "-"
    case multiply = "X"
    case divide = "/"

    func calculate(_ number1: Double, _ number2: Double) throws -> Double {
        switch self {
        case .add: return number1 + number2
        case .subtract: return number1 - number2
        case .multiply: return number1 * number2
        case .divide:
            if number2 == 0 {
                throw CalculatorErrors.divisionByZero
            }
            return number1 / number2
        }

    }
}

enum CalculatorHistory {
    case number(Double)
    case operation(Operation)
}

class ViewController: UIViewController {

    @IBAction func buttonPressed(_ sender: UIButton) {
        // создаем переменную значение который берется из ввода при нажатии
        guard let buttonText = sender.configuration?.title else { return }

        if buttonText == "," && (label.text?.contains(",") == true) { return }

        // при нажатии на кнопку С - обнуляем инпут
        if buttonText == "C" {
            label.text = "0"
            return
        }

        if label.text == "0" {
            // если в инпуте изначально ноль то заменяем ноль на новый знак
            label.text = buttonText
        } else {
            //если там не ноль то добавляем ноль в строку после цифры
            label.text?.append(buttonText)
        }
    }
    @IBAction func unwindAction(unwindSegue: UIStoryboardSegue) {}
    
    
    @IBAction func unwindActionCase(unwindSegue: JustCheckSegwei){}

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {  // переписываем функцию подготовки нового сториборда
        guard segue.identifier == "CALCULATIONS_LIST",
            let calculationsListVC = segue.destination
                as? CalculCalculationListViewController
        else { return }
        calculationsListVC.result = label.text
    }

    @IBAction func showCalculationsList(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let calculationsListVC = sb.instantiateViewController(
            identifier: "CalculationsListViewController"
        )

        if let vc = calculationsListVC as? CalculCalculationListViewController {
            vc.result = label.text
        }

        show(calculationsListVC, sender: self)
    }

    @IBAction func operationButtonPressed(_ sender: UIButton) {
        // при нажатии на кнопки вычислений ...

        // получаем знак с кнопки:
        guard let buttonText = sender.configuration?.title else { return }
        // выбираем кейс из перечислений сопоставляя со знаком: +,-,*,/
        // чтобы сделать из него enum operation
        guard let buttonOperation = Operation(rawValue: buttonText) else {
            return
        }
        guard
            //берем текст знака из инпута и форматируем в цифру
            let labelText = label.text,
            let labelNumber = numberFormatter.number(from: labelText)?
                .doubleValue
        else { return }
        // отправляем в массив цифры
        calculatorHistory.append(.number(labelNumber))
        // отправляем в массив операнд
        calculatorHistory.append(.operation(buttonOperation))
        // очищаем инпут для ввода числа
        resetLabel()
    }

    @IBAction func clearButtonPressed() {
        calculatorHistory.removeAll()
        resetLabel()
    }

    @IBAction func calculateButtonPressed() {
        // при нажатии на кнопку "="...
        guard
            //берем текст и форматируем ее в цифру
            let labelText = label.text,
            let labelNumber = numberFormatter.number(from: labelText)?
                .doubleValue
        else { return }
        // добавляем в массив
        calculatorHistory.append(.number(labelNumber))

        do {
            let result = try calculate()
            //показываем в инпуте результат и далее очищаем массив значений
            label.text = numberFormatter.string(from: NSNumber(value: result))
        } catch {
            label.text = "Error"
        }

        calculatorHistory.removeAll()

    }
    @IBOutlet weak var label: UILabel!

    var calculatorHistory: [CalculatorHistory] = []

    lazy var btn: UIButton = {
        $0.backgroundColor = .systemBlue
        $0.setTitle("Hello", for: .normal)
        $0.layer.cornerRadius = 10
        $0.frame.size = CGSize(width: 50, height: 100)
        $0.frame.origin = CGPoint(x: 100, y: 100)
        return $0
    }(UIButton())

    lazy var numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.usesGroupingSeparator = false
        numberFormatter.locale = Locale(identifier: "ru_RU")
        numberFormatter.numberStyle = .decimal

        return numberFormatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        resetLabel()
        view.addSubview(btn)
    }

    func calculate() throws -> Double {
        guard case .number(let firstNumber) = calculatorHistory.first else {
            return 0
        }
        var currentResult = firstNumber

        for index in stride(from: 1, to: calculatorHistory.count - 1, by: 2) {
            guard case .operation(let operation) = calculatorHistory[index],
                case .number(let number) = calculatorHistory[index + 1]
            else { break }
            currentResult = try operation.calculate(currentResult, number)
        }
        return currentResult
    }

    func resetLabel() {
        label.text = "0"
    }

}
