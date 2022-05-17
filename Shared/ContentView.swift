//
//  ContentView.swift
//  Shared
//
//  Created by Leo Driesch on 09.05.22.
//

import CoreData
import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Workout.createdAt, ascending: true)],
        animation: .default)
    private var workouts: FetchedResults<Workout>

    @State private var showCreationSheet = false

    @State private var editWorkout: Workout? = nil

    @State private var newWorkoutName = ""

    @State private var searchText = ""

    var body: some View {
        NavigationView {
            List {
                ForEach(searchText.isEmpty ?
                    workouts.filter { _ in true }
                    : workouts.filter { $0.name?.localizedCaseInsensitiveContains(searchText) ?? false }
                ) { workout in
                    NavigationLink(workout.name ?? "Unnamed Workout") {
                        WorkoutPage(workout: workout)
                    }
                    .contextMenu {
                        Button(action: {
                            editWorkout = workout
                        }) {
                            HStack {
                                Text("Edit")
                                Image(systemName: "pencil")
                            }
                        }
                        Divider()
                        Button(role: .destructive, action: {
                            withAnimation {
                                viewContext.delete(workout)

                                do {
                                    try viewContext.save()
                                } catch {
                                    // Replace this implementation with code to handle the error appropriately.
                                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                                    let nsError = error as NSError
                                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                                }
                            }
                        }) {
                            HStack {
                                Text("Delete")
                                Image(systemName: "trash")
                            }
                        }
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .sheet(item: $editWorkout, onDismiss: save) { workout in
                WorkoutSheet(editWorkout: workout)
            }
            .navigationTitle("Workouts")
            .toolbar {
                ToolbarItem {
                    Button(action: { showCreationSheet = true }) {
                        Label("Add Item", systemImage: "plus.circle")
                    }.sheet(isPresented: $showCreationSheet, onDismiss: save) {
                        WorkoutSheet(editWorkout: nil)
                    }
                }
            }
            .searchable(text: $searchText)
        }
    }

    private func save() {
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
            offsets.map { workouts[$0] }.forEach(viewContext.delete)

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

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
