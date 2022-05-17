//
//  CreateWorkoutSheet.swift
//  workout-planner
//
//  Created by Leo Driesch on 09.05.22.
//

import SwiftUI

struct WorkoutSheet: View {
    let editWorkout: Workout?

    var isEditing: Bool {
        editWorkout != nil
    }

    @Environment(\.dismiss) var dismiss

    @Environment(\.managedObjectContext) private var viewContext

    @State var workoutName = ""

    private func handleDone() {
        if isEditing {
            editWorkout?.name = workoutName
        } else {
            let workout = Workout(context: viewContext)
            workout.createdAt = Date()
            workout.name = workoutName
        }

        dismiss()
    }

    var body: some View {
        NavigationView {
            Form {
                TextField("Workout name", text: $workoutName).onAppear {
                    if let previousWorkoutName = editWorkout?.name {
                        workoutName = previousWorkoutName
                    }
                }
            }
            .navigationTitle(isEditing ? "Edit Workout" : "Create Workout")
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
                        Button(action: handleDone) {
                            Text(isEditing ? "Done" : "Add")
                        }
                    }
                }
        }
    }
}

struct CreateWorkoutSheet_Previews: PreviewProvider {
    static var previews: some View {
        Text("Background").sheet(isPresented: .constant(true)) {
            WorkoutSheet(editWorkout: nil)
        }
    }
}
