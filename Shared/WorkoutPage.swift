//
//  WorkoutPage.swift
//  workout-planner
//
//  Created by Leo Driesch on 09.05.22.
//

import SwiftUI

struct WorkoutPage: View {
    let workout: Workout

    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \SetItem.createdAt, ascending: true)],
        animation: .default)
    private var sets: FetchedResults<SetItem>

    @State private var showAddSetsSheet = false

    var body: some View {
        List {
            ForEach(sets) { setItem in
                HStack {
                    Text(setItem.name!)
                    Spacer()
                    Text("\(setItem.amount) sets")
                        .foregroundColor(.secondary)
                }.padding(.vertical)
            }
            .onDelete(perform: deleteItems)
        }
        .navigationTitle(workout.name!)
        .toolbar {
            ToolbarItem {
                Button(action: { showAddSetsSheet = true }) {
                    Label("Add Item", systemImage: "plus.circle")
                }.sheet(isPresented: $showAddSetsSheet) {
                    SetSheet(workout: workout, afterCreate: saveSetItem)
                }
            }
        }
    }

    private func saveSetItem() {
        withAnimation {
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { sets[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct WorkoutPage_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutPage(workout: Workout())
    }
}
