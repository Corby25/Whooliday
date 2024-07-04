import SwiftUI
import Firebase
import GoogleSignInSwift

struct SigninView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showingSignup = false
    @EnvironmentObject var authModel: AuthModel
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                backgroundGradient
                
                
                    VStack(spacing: 25) {
                        logoView
                        welcomeText
                        inputFields
                        forgotPasswordButton
                        signinButtons
                        divider
                        signupPrompt
                    }
                    .padding(.horizontal, 30)
                    .frame(minHeight: geometry.size.height)
                }
            
        }
        .navigationBarHidden(true)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    private var backgroundGradient: some View {
        LinearGradient(gradient: Gradient(colors: [Color.orange.opacity(1), Color.orange.opacity(1)]),
                       startPoint: .topLeading,
                       endPoint: .bottomTrailing)
            .ignoresSafeArea()
    }
    
    private var logoView: some View {
        Image("logosmall")
            .resizable()
            .scaledToFit()
            .frame(width: 100, height: 100)
            .foregroundColor(.white)
    }
    
    private var welcomeText: some View {
        Text("Ready to travel?")
            .font(.largeTitle)
            .fontWeight(.bold)
            .foregroundColor(.white)
    }
    
    private var inputFields: some View {
        VStack(spacing: 20) {
            CustomTextField(text: $email, placeholder: "Email", icon: "envelope")
            CustomTextField(text: $password, placeholder: "Password", icon: "lock", isSecure: true)
        }
    }
    
    private var forgotPasswordButton: some View {
        Button(action: handleResetPassword) {
            Text("Forgot Password?")
                .foregroundColor(.white)
                .font(.subheadline)
                .fontWeight(.semibold)
        }
    }
    
    private var signinButtons: some View {
        VStack(spacing: 15) {
            Button(action: signIn) {
                Text("Sign In")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)
                    .foregroundColor(.red)
                    .fontWeight(.bold)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
            }
            
            GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(scheme: .light, style: .standard, state: .normal)) {
                Task {
                    do {
                        try await authModel.signInGoogle()
                    } catch {
                        handleSignInError(error)
                    }
                }
            }
            .frame(width: 100 ,height: 50)
            
        }
    }
    
    private var divider: some View {
        HStack {
            VStack { Divider().background(Color.white) }
            Text("OR").foregroundColor(.white).font(.caption)
            VStack { Divider().background(Color.white) }
        }
    }
    
    private var signupPrompt: some View {
        Text("Don't have an account? Sign Up")
            .foregroundColor(.white)
            .font(.subheadline)
            .fontWeight(.semibold)
            .onTapGesture {
                self.showingSignup = true
            }
            .navigationDestination(isPresented: $showingSignup) {
                SignupView()
            }
    }
    
    private func signIn() {
        Task {
            do {
                try await authModel.signIn(withEmail: email, password: password)
            } catch {
                handleSignInError(error)
            }
        }
    }
    
    private func handleResetPassword() {
        if email.isEmpty || !isValidEmail(email) {
            alertMessage = "Please enter a valid email address."
            showAlert = true
        } else {
            Task {
                do {
                    try await authModel.resetPassword(email: email)
                    alertMessage = "Password reset email sent."
                    showAlert = true
                } catch {
                    alertMessage = "Failed to send password reset email, please try again."
                    showAlert = true
                }
            }
        }
    }
    
    private func handleSignInError(_ error: Error) {
        switch (error as NSError).code {
        case 17004:
            alertMessage = "Incorrect email address or password, please try again"
        case 17008:
            alertMessage = "The email is not in the correct format, please try again"
        case 17009:
            alertMessage = "The email or the password is missing, please try again"
        default:
            alertMessage = "Something went wrong, please try again"
        }
        showAlert = true
        password = ""
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPredicate.evaluate(with: email)
    }
}

struct CustomTextField: View {
    @Binding var text: String
    let placeholder: String
    let icon: String
    var isSecure: Bool = false
    
    var body: some View {
        HStack {
            Image(systemName: icon).foregroundColor(.white)
            if isSecure {
                SecureField(placeholder, text: $text)
            } else {
                TextField(placeholder, text: $text)
                    .keyboardType(placeholder == "Email" ? .emailAddress : .default)
                    .autocapitalization(.none)
                
                    
            }
            
        }
        .padding()
        .background(Color.white.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.white, lineWidth: 1))
        .fontWeight(.semibold)
        
    }
}

struct SigninView_Previews: PreviewProvider {
    static var previews: some View {
        SigninView().environmentObject(AuthModel())
    }
}
