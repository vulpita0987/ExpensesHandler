//
//  ExpenseAddView.swift
//  ExpansesHolder30043859
//
//  Created by Bucur I (FCES) on 01/03/2024.
//

import SwiftUI

struct ExpenseAddView: View {
    @ObservedObject var expenseList:Expenses
    @State private var showImagePicker = false//bool for image picker
    @State var image:Image?
    @State private var inputImage: UIImage?
    @StateObject var newExpense = Expense(name:"", description:"", paid:false, VATIncluded:false, amount:0, expenseAddedDate:Date(), expensePaidDate:Date(), dateOnReceipt: Date())
    
    
    @Environment(\.dismiss) private var dismiss
    
    func loadImage(){//function used to load image
        guard let inputImage = inputImage else {return}
        image = Image(uiImage:inputImage)
        newExpense.image = inputImage
    }
    
    
    
    var body: some View {
        
        VStack{
            HStack{
                Button(action:{//cancel action
                    dismiss()
                }){
                    Text("Cancel")
                }
                Spacer()
                Button(action:{//save button
                    //append the new expense to the Expenses list
                    expenseList.expenses.append(newExpense)
                    //save data from main variables to the edit variables
                    //to show the variables the first time the user access the edit view
                    newExpense.editDescription =  newExpense.description
                    newExpense.editName =  newExpense.name
                    //newExpense.editPaid = newExpense.paid
                    newExpense.editVATIncluded = newExpense.VATIncluded
                    newExpense.editAmount = newExpense.amount
                    newExpense.editExpensePaidDate = newExpense.expensePaidDate
                    newExpense.editDateOnReceipt = newExpense.dateOnReceipt
                    newExpense.editImage = newExpense.image
                    dismiss()
                }){
                    Text("Save")
                }
            }}.padding(.bottom, 120).padding(.leading, 10).padding(.trailing, 10)
            .padding(.top, 20)
            VStack(alignment: .leading){
                
                ZStack{
                    
                    TextField("Enter name", text:$newExpense.name).frame(width:200, height:0, alignment: .trailing).multilineTextAlignment(.leading)
                 
                    Text("Name:").multilineTextAlignment(.leading).padding(.trailing, 250.0)}
                .padding(5).padding(.leading, 0)
                
                ZStack{
                   
                    TextField("Description", text:$newExpense.description).frame(width:150, height:0, alignment: .leading).multilineTextAlignment(.leading)
                    
                    Text("Description:").multilineTextAlignment(.leading).padding(.trailing, 240.0)}
                .padding(5)
                
                ZStack{
                   
                  
                    Toggle(isOn: $newExpense.VATIncluded) {
                        Text("VAT Inclusion:")
                     Text(newExpense.VATIncluded ? "Vat Included" : "Vat Excluded")
                        
                    }
                    .padding(5)
                    
                   .padding(.trailing, 115.0)}
              
                
                ZStack{
                    TextField("Amount", value:$newExpense.amount, format: .number).frame(width:150, height:0, alignment: .leading).multilineTextAlignment(.leading)
                    
                    Text("Amount:£").multilineTextAlignment(.leading).padding(.trailing, 230.0)
                    
                }.padding(.leading, 5)
                
                ZStack{
                    
                    if(newExpense.VATIncluded == true){
                        
                        let amountWithVAT = newExpense.amount*1.2
                        let forDisplay = String(format: "%.2f", arguments: [amountWithVAT])
                        
                        Text("Amount (with VAT): £ \(forDisplay)").multilineTextAlignment(.leading).padding(.trailing, 0.0)}
                }.padding(5).padding(.bottom, 10).padding(.leading, 0.0).frame(width: 300.0, alignment: .leading)
                
                ZStack{
                    
                    DatePicker(selection: $newExpense.dateOnReceipt, label: { Text("Date On Receipt:") }).frame(width: 340.0, height: 10.0, alignment: .leading).padding(.leading, 5)
                }.padding(.bottom, 20)
                
                ZStack{//used to show image picker - allows user to choose an image
                    Rectangle().fill(.secondary)
                    Text("Tap to select a picture")
                        .foregroundColor(.white)
                        .font(.headline)
                    image?.resizable().scaledToFit()
                }.onTapGesture {
                    showImagePicker = true
                }.padding(.top, 0).frame(width: 360.0, height: 450)
                    .cornerRadius(50)
            }.frame(width: 360.0, height: 250.0, alignment: .center)
                
            
                .padding(.top, 100)


            Spacer()
                .onChange(of: inputImage){_ in loadImage()}//if an image is loaded - update it so it show up
                .sheet(isPresented: $showImagePicker){
                    ImagePicker(image: $inputImage)
                    
                }
        }
    }
        
       
        
        


#Preview {
    ExpenseAddView(expenseList:Expenses())//used data from expenses
}
