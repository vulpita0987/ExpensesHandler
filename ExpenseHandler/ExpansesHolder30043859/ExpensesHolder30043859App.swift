//
//  ExpansesHolder30043859App.swift
//  ExpansesHolder30043859
//
//  Created by Bucur I (FCES) on 01/03/2024.
//comment

import SwiftUI

@main
struct ExpensesHolder30043859App: App {
    @StateObject private var data = Expenses()
    var body: some Scene {
        WindowGroup {
            ExpensesView(data:self.data){//save data in the Expense format
                Expenses.save(expenses: data.expenses){ result in
                    if case .failure(let error) = result{//in case there is an error- catch it
                        fatalError(error.localizedDescription)
                    }
                }
            }.onAppear{//load data from expenses into the main view
                Expenses.load{ result in
                    switch result{
                    case .failure(let error)://if data can not be loaded then let the error be caught
                        fatalError(error.localizedDescription)
                    case .success(let expenses)://if the data can be retrived successfuly then pass it to the StateObject
                        data.expenses = expenses
                    }
                    
                }
               
            }
        }
    }
}
