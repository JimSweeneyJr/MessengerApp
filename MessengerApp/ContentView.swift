//
//  ContentView.swift
//  MessengerApp
//
//  Created by James Sweeney on 8/15/23.
//

import SwiftUI
import Firebase

class FirebaseManager: NSObject {
    
    let auth: Auth
    
    static let shared = FirebaseManager()
    
    override init() {
        FirebaseApp.configure()
        
        self.auth = Auth.auth()
        
        super.init()
    }
    
}

struct ContentView: View {
    
    @State var isLoginMode = false
    @State var email = ""
    @State var password = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                
                VStack(spacing: 12){
                    Picker(selection: $isLoginMode, label:
                            Text("Picker here")) {
                            Text("Login")
                            .tag(true)
                            Text("Create Account")
                            .tag(false)
                    }.pickerStyle(SegmentedPickerStyle())
                        .padding()
                    
                    if !isLoginMode {
                        
                        Button {
                            
                        } label: {
                            Image(systemName: "person.fill")
                                .font(.system(size: 64))
                                .padding()
                        }
                    }
                   
                    Group {
                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                        SecureField("Password", text: $password)
                            
                    }
                    
                    .padding(12)
                    .background(Color.white)
            
                    Button {
                        handleAction()
                    } label: {
                        HStack {
                            Spacer()
                            Text(isLoginMode ? "Log In" : "Create Account")
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                                .font(.system(size: 14, weight: .semibold))
                            Spacer()
                        }
                        .background(Color.blue)
                    }
                }
                .navigationTitle(isLoginMode ? "Log In" : "Create Account")
                
                }
            .padding()
            .background(Color(.init(white: 0, alpha: 0.05)))

        }
    }
    private func handleAction() {
        if isLoginMode {
            print("Should log into Firebase with existing credentials")
            loginUser()
        } else {
            createNewAccount()
            
        }
    }
    
    private func loginUser() {
        FirebaseManager.shared.auth.signIn(withEmail: email, password: password)
    }
    
    @State var errorMessage = ""
    
    private func createNewAccount() {
        Auth.auth().createUser(withEmail: email, password: password) {
            result, error in
            if let error = error {
                print("Failed to create user")
                self.errorMessage = "Failed to create user"
                return
            }
            print("Successfully created user")
        }
    }
}
    
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
