//
//  NewClass.swift
//  GCD Tests
//
//  Created by Shevshelev Lev on 25.04.2022.
//

import Foundation

class NewClass {
    static let shared = NewClass()
    private var tasks: [() -> Void] = []
    private var currentTask: (() -> Void)?
    private init() {}
    
    func addTask(_ task: @escaping () -> Void) {
            tasks.append(task)
    }
    
    private func run() {
        DispatchQueue.global(qos: .background).async {
            self.currentTask = self.tasks.removeFirst()
            while self.currentTask != nil {
                guard let task = self.currentTask else { return }
                task()
                if self.tasks.isEmpty {
                self.currentTask = nil
                } else {
                    self.currentTask = self.tasks.removeFirst()
                }
            }
        }
    }
    
}
OperationQueue
