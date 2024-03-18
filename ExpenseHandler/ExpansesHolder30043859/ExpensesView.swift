//
//  ContentView.swift
//  ExpansesHolder30043859
//
//  Created by Bucur I (FCES) on 01/03/2024.
//
///aaaa
import SwiftUI

struct ExpensesView: View {
    
    @State var showView = false
    @State var searchText = ""
    @ObservedObject var data:Expenses
    
    @Environment(\.scenePhase) private var scenePhase
    let saveAction: ()->Void
    
    
    
    
    var body: some View {
        
        NavigationView{
            
            List(data.expenses.filter(
                {"\($0.name)".localizedCaseInsensitiveContains(searchText) || searchText.isEmpty})){ expense in
                    NavigationLink(//used for the search bar
                        destination: ExpenseDetailView(expense:expense)){
                            ExpenseRowView(expense:expense)
                        }.swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            
                            Button("Mark as Unpaid")//button inside swipe action to mark as unpaid
                            {
                               
                                    expense.paid = false
                                    expense.editPaid = false
                                  
                                
                            }.tint(.orange)
                            
                            Button("Mark as Paid")//button inside swipe action to mark as paid
                            {
                               
                                    expense.paid = true
                                    expense.editPaid = true
                                    
                                   
                                    expense.expensePaidDate = Date()//set a new date for the paid date
                                
                                
                                
                            }.tint(.green)
                        }
                    
                        .swipeActions(edge: .leading, allowsFullSwipe: false) {
                            
                            Button("Delete")//delete button when swiping right
                            {
                                let selection = data.expenses.firstIndex(where: {$0.id == expense.id})
                                if let selectionIndex = selection{
                                    data.expenses.remove(at:selectionIndex)
                                }
                                
                               
                                
                                
                            }.tint(.red)
                        }
                    
               
                    
                }.background(.white)
            
                
            
                .toolbar{
                    
                    ToolbarItemGroup(placement: .primaryAction){
                        Text("Expenses").padding(.bottom, 0).font(.system(size: 40)).padding(.trailing, 80.0).multilineTextAlignment(.leading) .frame(alignment: .leading)//title of the application
                        Button("Add", systemImage: "doc.fill.badge.plus") {//add button + used icon
                            showView.toggle()
                        }.sheet(isPresented:$showView){
                            ExpenseAddView(expenseList:data)//shows expenses
                        }
                        
                        Menu{
                            
                            Picker(selection:$data.sortBy,//used to sort data
                                   label: Text("Sorting Options")){
                                Text("Paid").tag(0)
                                Text("Unpaid").tag(1)
                            }
                        }
                    label:{
                        Label("Sort", systemImage:"arrow.up.arrow.down")//image used to signify sort possibility
                    }
                        
                    }
                    
                }.searchable(text:$searchText)
                
                .background(.red)
               
                .onChange(of: scenePhase){ phase in//save actions done on scene
                    if phase == .inactive { saveAction()}
                }}.padding(.top, 10)
    }
}
    


#Preview {
    ExpensesView(data:Expenses(),saveAction:{})//use data from expenses, if scene changes then save the changes
}
