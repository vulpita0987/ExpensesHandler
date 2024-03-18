//
//  ExpenseDetailView.swift
//  ExpansesHolder30043859
//
//  Created by Bucur I (FCES) on 01/03/2024.
//

import SwiftUI

struct ExpenseDetailView: View {
    @StateObject var expense:Expense
    
    let formatter = DateFormatter()
  
    
    var body: some View {
        VStack{
            HStack{
                Text("Name: \(expense.name)" )//display name
                    .padding(.bottom, 10).frame(width: 370.0,alignment: .leading) .padding(.top, 10)
            }
            HStack{
                Text("Description: \(expense.description)")//display description
                    .padding(.bottom, 10).frame(width: 370.0,alignment: .leading)
            }
            HStack{
                Text("Paid:")
                Text(String(expense.paid))//display bool
            }.padding(.bottom, 10).frame(width: 370.0,alignment: .leading)
            HStack{
                Text("VAT Included:")
                Text(String(expense.VATIncluded))//display bool
            }.padding(.bottom, 10).frame(width: 370.0,alignment: .leading)
            HStack{
                let amountWithoutVAT = expense.amount
                let forDisplayWithoutVAT = String(format: "%.2f", arguments: [amountWithoutVAT])
                Text("Amount:£ \(forDisplayWithoutVAT)")//display amount without VAT
                    .padding(.bottom, 15).frame(width: 370.0,alignment: .leading)
            }
            HStack{
                let amountWithVAT = expense.amount*1.2
                let forDisplayWithVAT = String(format: "%.2f", arguments: [amountWithVAT])
                if(expense.VATIncluded == true){
                    
                    Text("Amount (with VAT):£ \(forDisplayWithVAT)").multilineTextAlignment(.leading).padding(.trailing, 20.0).padding(.bottom, 10).frame(width: 370.0, alignment: .leading)}//display amount with VAT
                //only if the VAT is on for the expense
            }
            HStack{
                //display the date when the expense was added
                DatePicker(selection: $expense.expenseAddedDate, label: { Text("Expense Added Date:")
                }).frame(width: 370.0, height: 20, alignment: .leading)
                    .disabled(true).padding(.bottom, 10)
            }
            HStack{
                //display the date when the deceipt was issued
                DatePicker(selection: $expense.dateOnReceipt, label: { Text("Date On Receipt:") }).frame(width: 370.0, height: 20.0, alignment: .leading)
                    .disabled(true).padding(.bottom, 10)
            }
            HStack{
                //display the date when the expense was paid if the expense has been paid
                if(expense.paid == true){
                    DatePicker(selection: $expense.expensePaidDate, label: { Text("Expense Paid Date:") }).frame(width: 370.0, height: 20, alignment: .leading)
                        .disabled(true).padding(.bottom, 10)

                }
            }
            HStack{
                if let image = expense.image{
                    Image(uiImage:image).resizable().aspectRatio(contentMode: .fit)
                        .padding(.top, 10).frame(width: 370.0, height: 300, alignment: .center)
                        .padding(.bottom, 10).background(.gray ).clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
            
        }.frame(width: 360.0, height: 600.0, alignment: .center).padding(.bottom, 100)
        //Edit button as part of the navigation items - expense is used to show the view
        .navigationBarItems(trailing:NavigationLink("Edit"){ExpenseEditView(expense: expense)})
    }
}

#Preview {
    ExpenseDetailView(expense:Expense(name:"Example", description:"012345", paid:false,VATIncluded:false, amount:0, expenseAddedDate:Date(), expensePaidDate:Date(), dateOnReceipt:Date()))//give examples of what data to use 
}
