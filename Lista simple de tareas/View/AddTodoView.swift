//
//  AddTodoView.swift
//  Lista simple de tareas
//
//  Created by Felix Angel Abalia Macias on 10/3/21.
//

import SwiftUI

struct AddTodoView: View {
    
    // MARK: PROPERTIES
    @Environment(\.managedObjectContext) var  managedObjectContext
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name: String = ""
    @State private var priority: String = "Normal"
    
    let priorities = ["High", "Normal", "Low"]
    
    @State private var errorShowing = false
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    
    // MARK: BODY
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    // MARK: - TODO NAME
                    TextField("Tarea", text: $name)
                    
                    // MARK: - TODO PRIORITY
                    Picker("Prioridad", selection: $priority) {
                        ForEach(priorities, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    // MARK: - SAVE BUTTON
                    Button(action: {
                        if self.name != "" {
                            let todo = ToDo(context: self.managedObjectContext)
                            todo.name = self.name
                            todo.priority = self.priority
                            do {
                                try self.managedObjectContext.save()
                                print("New Todo: \(todo.name ?? "") priority: \(todo.priority ?? "")")
                            } catch {
                                print(error)
                            }
                        } else {
                            self.errorShowing = true
                            self .errorTitle = "Tarea no válida"
                            self.errorMessage = "Asegúrate de introducir un nombre para la tarea"
                            return
                        }
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Guardar")
                    } // MARK: SAVE BUTTON
                }// :FORM
                Spacer()
            }// :VSTACK
            .navigationBarTitle("Tarea", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "xmark")
            })
            .alert(isPresented: $errorShowing, content: {
                Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("Aceptar")))
            })
        }// :NAVIGATION
        
    }
}

// MARK: PREVIEW
struct AddTodoView_Previews: PreviewProvider {
    static var previews: some View {
        AddTodoView()
    }
}
