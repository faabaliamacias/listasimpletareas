//
//  ContentView.swift
//  Lista simple de tareas
//
//  Created by Felix Angel Abalia Macias on 10/3/21.
//

import SwiftUI

struct ContentView: View {
    // MARK: PROPERTIES
    
    @Environment(\.managedObjectContext) var  managedObjectContext
    
    @FetchRequest(entity: ToDo.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \ToDo.name, ascending: true)]) var todos: FetchedResults<ToDo>
    
    @State private var showingAddTodoView: Bool = false
    
    // MARK: BODY
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(self.todos, id: \.self) { todo in
                        HStack {
                            Text(todo.name ?? "Desconocida")
                            
                            Spacer()
                            
                            Text(todo.priority ?? "Desconocida")
                        }
                    } //: FOREACH
                    .onDelete(perform: deleteTodo)
                }// : LIST
                .navigationBarTitle("Lista de tareas", displayMode: .inline)
                .navigationBarItems(
                    leading: EditButton(),
                    trailing: Button(action: {
                        self.showingAddTodoView.toggle()
                    }) {
                        Image(systemName: "plus")
                    } // :ADD BUTTON
                )
                .sheet(isPresented: $showingAddTodoView) {
                    AddTodoView().environment(\.managedObjectContext, self.managedObjectContext)
                }
                
                // MARK: - NO TODO ITEMS
                if todos.count == 0 {
                    EmptyListView()
                }
            } //: ZSTACK
        } //: NAVIGATION
    }
    
    // MARK: - FUNCTIONS
    
    private func deleteTodo(at offsets: IndexSet) {
        for index in offsets {
            let todo = todos[index]
            managedObjectContext.delete(todo)
            
            do {
                try managedObjectContext.save()
            } catch {
                print(error)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return ContentView()
            .environment(\.managedObjectContext, context)
    }
}
