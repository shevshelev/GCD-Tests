//
//  PrimesNumberViewController.swift
//  GCD Tests
//
//  Created by Shevshelev Lev on 23.04.2022.
//

import UIKit

class PrimesNumberViewController: UIViewController {
    
    private lazy var numberTF: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Max number"
        textField.textAlignment = .center
        textField.keyboardType = .numberPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var startButton: UIButton = {
        let button = UIButton()
        button.setTitle("Calculate", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSubviews()
    }
    
    override func viewWillLayoutSubviews() {
        NSLayoutConstraint.activate([
            numberTF.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            numberTF.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            numberTF.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -32),
            numberTF.heightAnchor.constraint(equalToConstant: 40),
            
            startButton.topAnchor.constraint(equalTo: numberTF.bottomAnchor, constant: 10),
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.widthAnchor.constraint(equalTo: numberTF.widthAnchor),
            startButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setupSubviews() {
        let subviews = [numberTF, startButton]
        subviews.forEach { view.addSubview($0) }
        startButton.addTarget(self, action: #selector(startButtonPressed), for: .touchUpInside)
    }
    
    @objc private func startButtonPressed() {
        if let text = numberTF.text {
            view.endEditing(true)
            guard let max = Int(text) else { print("Enter max value!"); return }
            if max > 1 {
                DispatchQueue.global(qos: .userInitiated).async {
                    let start = Date()
                    let numbers = self.findPrimesNumber(upTo: max)
                    let stringNumbers = numbers.reduce("") {"\($0) \($1)"}
                    let end = Date()
                    print("Время: \(String(format: "%.2f", (end.timeIntervalSince(start))))")
                    print(stringNumbers)
                }
            } else {
                print("Max value must be greater 1")
            }
        }
    }
    
    private func findPrimesNumber(upTo max: Int) -> [Int] {
        var testValue = 2
        var numbers = (2...max).map { $0 }
        
        while (testValue * testValue <= max) {
            numbers.removeAll(where: { $0 >= testValue * testValue && $0.isMultiple(of: testValue)})
            testValue = numbers.first(where: { $0 > testValue}) ?? 0
        }
        return numbers
    }
}
