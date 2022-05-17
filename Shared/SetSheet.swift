//
//  AddSetsSheet.swift
//  workout-planner
//
//  Created by Leo Driesch on 09.05.22.
//

import SwiftUI

struct SetSheet: View {
    let workout: Workout
    
    let afterCreate: () -> Void
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var setAmount = 3
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Exercise name", text: $name)
                
                Stepper("\(setAmount) sets",
                        onIncrement: { setAmount += 1 },
                        onDecrement: { setAmount = max(setAmount - 1, 0) })
            }
            .navigationTitle("Add Sets")
#if os(iOS)
                .navigationBarTitleDisplayMode(.inline)
#endif
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button(action: { dismiss() }) {
                            Text("Cancel")
                        }
                    }
                
                    ToolbarItem(placement: .confirmationAction) {
                        Button(action: {
                            let setItem = SetItem(context: viewContext)
                            setItem.workout = workout
                            setItem.createdAt = Date()
                            setItem.name = name
                            setItem.amount = Int16(setAmount)
                      
                            afterCreate()
                        
                            dismiss()
                        }) {
                            Text("Add")
                        }
                    }
                }
        }
    }
}

struct AddSetsSheet_Previews: PreviewProvider {
    static var previews: some View {
        SetSheet(workout: Workout(), afterCreate: {})
    }
}
