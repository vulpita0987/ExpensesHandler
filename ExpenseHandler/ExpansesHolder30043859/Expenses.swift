//
//  Expenses.swift
//  ExpansesHolder30043859
//
//  Created by Bucur I (FCES) on 01/03/2024.
//

import Foundation
class Expenses:ObservableObject{
    @Published var expenses:[Expense] = []
    
    @Published var sortBy:Int = 0{//sort function
        didSet{
            if (sortBy==0){//sorts for paid first
                expenses.sort{
                    $0.paid && !$1.paid
                }
            }else{//sorts for unpaid first
                expenses.sort{
                    !$0.paid && $1.paid
                }
            }
        }
    }
    
    private static func fileURL() throws -> URL{//used to append data to container file(expenses.data)
        try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create:false)
            .appendingPathComponent("expenses.data")
    }
    
    
    
    static func save(expenses:[Expense], completion: @escaping (Result<Int, Error>)->Void){//used to save data to container file
        DispatchQueue.global(qos: .background).async{
            do{
                let data = try JSONEncoder().encode(expenses)
                let outfile = try fileURL()
                try data.write(to:outfile)
                DispatchQueue.main.async{
                    completion(.success(expenses.count))
                }
            }catch {//used to catch possible error - if data can not be saved
                DispatchQueue.main.async{
                    completion(.failure(error))
                }
            }
        }
    }
    
    static func load(completion: @escaping (Result<[Expense], Error>)->Void){//used to load data from the container file
        DispatchQueue.global(qos: .background).async{
            do{
                let fileURL = try fileURL()
                guard let file = try? FileHandle(forReadingFrom: fileURL) else {//try reading from file
                    DispatchQueue.main.async{
                        completion(.success([]))
                    }
                        return
                    }
                let newExpense = try JSONDecoder().decode([Expense].self, from: file.availableData)//decode the data
                DispatchQueue.main.async{
                    completion(.success(newExpense))
                    }
            }catch{//catch the error 
                DispatchQueue.main.async{
                    completion(.failure(error))
                }
            }
        }
    }
}
