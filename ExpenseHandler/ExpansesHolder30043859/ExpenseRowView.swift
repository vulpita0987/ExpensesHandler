//
//  ExpenseRowView.swift
//  ExpansesHolder30043859
//
//  Created by Bucur I (FCES) on 01/03/2024.
//

import SwiftUI
import UIKit

struct ExpenseRowView: View {
    @StateObject var expense:Expense
    
    
    var body: some View {
        HStack{
            VStack(alignment: .leading){
                Text(expense.name)//show name of the expenses
            }.frame(width: 200.0, height: 10.0, alignment: .leading)
                .padding(20)
            Spacer()
            if(expense.paid == true)//if the expense is marked as paid do it
            {//used to have different colouring for paid and unpaid expenses
                Text(expense.name.prefix(1))
                    .font(.title2)
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.center)
                    .padding(0.0)
                    .frame(width: 25.0, height: 30.0, alignment: .center)
                    .background(Color.green)
                    .clipShape(Circle())
            }
            if(expense.paid == false)//if the expense is marked as unpaid do this
            {//used to have different colouring for paid and unpaid expenses
                Text(expense.name.prefix(1))
                    .font(.title2)
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.center)
                    .padding(0.0)
                    .frame(width: 25.0, height: 30.0, alignment: .center)
                    .background(Color.red)
                    .clipShape(Circle())
            }
            
            
            Spacer()
            
        }
    }
}

#Preview {
    ExpenseRowView(expense:Expense(name:"Example", description:"012345", paid:false,VATIncluded:false, amount:0, expenseAddedDate:Date(), expensePaidDate:Date(), dateOnReceipt:Date()))//give examples of what data to use 
}
