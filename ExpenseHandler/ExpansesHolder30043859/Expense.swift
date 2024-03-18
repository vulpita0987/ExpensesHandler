//
//  Expanse.swift
//  ExpansesHolder30043859
//
//  Created by Bucur I (FCES) on 01/03/2024.
//

import Foundation
import SwiftUI

class Expense:Identifiable, ObservableObject,Codable{
    let id = UUID()//unique id for each expense
    @Published var name:String//define expense details
    @Published var description:String
    @Published var paid:Bool = false
    @Published var VATIncluded:Bool = false
    @Published var amount:Double
    @Published var expenseAddedDate:Date
    @Published var expensePaidDate:Date
    @Published var dateOnReceipt:Date
    @Published var image:UIImage?
    
    @Published var editName:String//define expense details to edit
    @Published var editDescription:String
    @Published var editPaid:Bool = false
    @Published var editVATIncluded:Bool
    @Published var editAmount:Double
    @Published var editExpenseAddedDate:Date
    @Published var editExpensePaidDate:Date
    @Published var editDateOnReceipt:Date
    @Published var editImage:UIImage?
    
    //class constructor
    init (name:String, description:String, paid:Bool, VATIncluded:Bool, amount:Double, expenseAddedDate:Date, expensePaidDate:Date, dateOnReceipt:Date){
        self.name = name
        self.description = description
        self.paid = paid
        self.VATIncluded = VATIncluded
        self.amount = amount
        self.expenseAddedDate = expenseAddedDate
        self.expensePaidDate = expensePaidDate
        self.dateOnReceipt = dateOnReceipt
       
        
        self.editName = name
        self.editDescription = description
        self.editPaid = paid
        self.editVATIncluded = VATIncluded
        self.editAmount = amount
        self.editExpenseAddedDate = expenseAddedDate
        self.editExpensePaidDate = expensePaidDate
        self.editDateOnReceipt = dateOnReceipt
        
        
    }
    
    
    enum CodingKeys:CodingKey{//keys used to encode and decode (what variables will be used)
        case name, description, paid, VATIncluded, amount, expenseAddedDate, expensePaidDate, dateOnReceipt, id
    }
    
    func encode(to encoder: Encoder) throws{//used to encode the variables so that they can be passed to the container file
        writeImageToDisk()//used to write image to the same file
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(name, forKey: .name)
        try container.encode(description, forKey: .description)
        try container.encode(paid, forKey: .paid)
        try container.encode(VATIncluded, forKey: .VATIncluded)
        try container.encode(amount, forKey: .amount)
        try container.encode(expenseAddedDate, forKey: .expenseAddedDate)
        try container.encode(expensePaidDate, forKey: .expensePaidDate)
        try container.encode(dateOnReceipt, forKey: .dateOnReceipt)
        
    }
    
    required init(from decoder: Decoder) throws{//used to decode data that is in container file so that it can be displayed
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let loadedName = try container.decode(String.self, forKey: .name)
        let loadedDescription = try container.decode(String.self, forKey: .description)
        let loadedPaid = try container.decode(Bool.self, forKey: .paid)
        let loadedVATIncluded = try container.decode(Bool.self, forKey: .VATIncluded)
        let loadedAmount = try container.decode(Double.self, forKey: .amount)
        let loadedExpenseAddedDate = try container.decode(Date.self, forKey: .expenseAddedDate)
        let loadedExpensePaidDate = try container.decode(Date.self, forKey: .expensePaidDate)
        let loadedDateOnReceipt = try container.decode(Date.self, forKey: .dateOnReceipt)
        
        name = loadedName
        description = loadedDescription
        paid = loadedPaid
        VATIncluded = loadedVATIncluded
        amount = loadedAmount
        expenseAddedDate = loadedExpenseAddedDate
        expensePaidDate = loadedExpensePaidDate
        dateOnReceipt = loadedDateOnReceipt
        
        editName = loadedName
        editDescription = loadedDescription
        editPaid = loadedPaid
        editVATIncluded = loadedVATIncluded
        editAmount = loadedAmount
        editExpenseAddedDate = loadedExpenseAddedDate
        editExpensePaidDate = loadedExpensePaidDate
        editDateOnReceipt = loadedDateOnReceipt
        
        //used to check if an image is associated with the expense - images are linked to the unique expenseAddedDate
        let imagePath = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create:false).appendingPathComponent("\(expenseAddedDate).jpeg")
        
        if let loadPath = imagePath{
            print(loadPath)
            if let data = try? Data(contentsOf: loadPath){
                self.image = UIImage(data: data)
                print("loaded")
            }
        }
    }
    
    func writeImageToDisk() {//used to write the image to the container file to later be used
        if let imageToSave = self.image{
            let imagePath = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create:false).appendingPathComponent("\(expenseAddedDate).jpeg") //uses the same unique expenseAddedDate to link to
            if let jpegData = imageToSave.jpegData(compressionQuality: 0.5) {
                if let savePath = imagePath{
                    try? jpegData.write(to: savePath, options: [.atomic, .completeFileProtection])
                    print("saved \(savePath)")
                }
            }
        }
    }
}

