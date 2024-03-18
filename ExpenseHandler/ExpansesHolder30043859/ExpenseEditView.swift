// hello
//  ExpenseEditView.swift
//  ExpansesHolder30043859
//
//  Created by Bucur I (FCES) on 01/03/2024.
//

import SwiftUI
import LocalAuthentication

struct ExpenseEditView: View {
    @StateObject var expense:Expense
    @Environment(\.dismiss) private var dismiss
    
   
    
    @State private var showImagePicker = false
    @State var image:Image?
    @State private var inputImage: UIImage?
    
    func loadImage(){//used to load image
        guard let inputImage = inputImage else {return}
        image = Image(uiImage:inputImage)
        expense.editImage = inputImage
       
    }
    
    
  func authenticateSave() {//used to do authentication when editing expenses
        let context = LAContext()
        var error: NSError?
        
        //checks if biometric authentication is possible
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
          
            let reason = "We need to unlock your data."

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                // completed authentication
                DispatchQueue.main.async {
                    if success {//authentication successful then do this
                expense.name = expense.editName
                expense.description = expense.editDescription
                expense.paid = expense.editPaid
                expense.VATIncluded = expense.editVATIncluded
                expense.amount = expense.editAmount
                expense.expensePaidDate = expense.editExpensePaidDate
                expense.dateOnReceipt = expense.editDateOnReceipt
                        
                if(expense.editImage != nil){expense.image = expense.editImage}
                        dismiss()
                        
                    } else {
                        // if used can not authenticate then print this
                        print("not authenticated")
                    }
                    dismiss()
                }
            }
            print("biometrics")
        } else {
            // no biometrics
            print("no biometrics")
            DispatchQueue.main.async {
                // if there is a problem with the authentication process show this in debugger
                print("not authenticated")
                dismiss()
            }
        }
    }
    
    var body: some View {
        VStack{
            //display name - allow user to edit it
            HStack{Text("Name: ")
                TextField("Name", text: $expense.editName)}.padding(.leading, 10).padding(.trailing, 10).padding(.bottom, 5)
            //display description - allow user to edit it
            HStack{Text("Description: ")
                TextField("Description", text: $expense.editDescription)}.padding(.leading, 10).padding(.trailing, 10).padding(.bottom, 5)
            
            
            
            //display bool for expensePaid as toggle - allow user to edit it
            Toggle(isOn: $expense.editPaid) {
                Text("Expense Paid:")
            }.padding(.leading, 10).padding(.trailing, 170).padding(.bottom, 5)
            //display bool for VAT inclusion as toggle - allow user to edit it
            Toggle(isOn: $expense.editVATIncluded) {
                Text("VAT Inclusion:")
                
            }.padding(.leading, 10).padding(.trailing, 170).padding(.bottom, 5)
            
            HStack{
                //display amount without VAT - allow user to edit it
                Text("Amount:£ ")
                TextField("Amount", value:$expense.editAmount, format: .number)}.padding(.leading, 10).padding(.trailing, 10).padding(.bottom, 5)
            
            HStack{
                //display amount with VAT - this is displayed only if the VAT is used (on) - allow user to edit it
                if(expense.editVATIncluded == true){
                    let amountWithVAT = expense.editAmount*1.2
                    let forDisplayWithVAT = String(format: "%.2f", arguments: [amountWithVAT])
                    Text("Amount (with VAT):£ \(forDisplayWithVAT)").frame(width: 370.0, height: 30.0, alignment: .leading).padding(.leading, 10).padding(.trailing, 10).padding(.bottom, 5)}
            }
            
            if(expense.editPaid == true){
                //display the date when the expense was paid - is only displayed if the expense is marked as paid - //allow user to edit it
                DatePicker(selection: $expense.editExpensePaidDate, label: { Text("Expense Paid Date:") }).frame(width: 370.0, height: 30.0, alignment: .leading).padding(.leading, 10).padding(.trailing, 10).padding(.bottom, 5)
            }
            
            //display the date on the receipt - allow user to edit it
            DatePicker(selection: $expense.editDateOnReceipt, label: { Text("Date On Receipt:") }).frame(width: 370.0, height: 30.0, alignment: .leading).padding(.leading, 10).padding(.trailing, 10).padding(.bottom, 5)
            
            //used to show the used picture or allow the user to select one if no picture is associated with the //expense - user can select different pictures multiple times
            ZStack(alignment: .center){
                if let image = expense.image{
                    Image(uiImage:image).resizable().aspectRatio(contentMode: .fit)
                        .frame(width: 370.0, height: 300, alignment: .center)
                }
                Rectangle().fill(.secondary)
                Text("Tap to select a picture")
                    .foregroundColor(.white)
                    .font(.headline)
                image?.resizable().scaledToFit()
            }  .frame(width: 380.0, height: 350, alignment: .center).onTapGesture {
                showImagePicker = true
                //show any changes that happen to the selected image
            } .cornerRadius(50).onChange(of: inputImage){_ in loadImage()}
                .sheet(isPresented: $showImagePicker){
                    ImagePicker(image: $inputImage)
                       
                }
            
            
        }.padding(.bottom, 50).navigationBarItems(trailing:Button("Save"){
            
            authenticateSave()//use function for authentication when saving
            
            
            
            
        })
        
        .onDisappear(perform:{//if the user goes back without saving then do not save the changes
            expense.editName = expense.name
            expense.editDescription = expense.description
            expense.editPaid = expense.paid
            expense.editVATIncluded = expense.VATIncluded
            expense.editAmount = expense.amount
            expense.editExpensePaidDate = expense.expensePaidDate
            expense.editDateOnReceipt = expense.dateOnReceipt
            
            expense.editImage = expense.image
            
        })
    }
}

#Preview {
    ExpenseDetailView(expense:Expense(name:"Example", description:"012345", paid:false,VATIncluded:false, amount:0, expenseAddedDate:Date(), expensePaidDate:Date(), dateOnReceipt:Date()))
    //give exaples of what data can be used
}
