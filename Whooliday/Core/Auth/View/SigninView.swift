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
            Alert(title: Text(NSLocalizedString("Error", comment: "Error alert title")),
                  message: Text(alertMessage),
                  dismissButton: .default(Text(NSLocalizedString("OK", comment: "Alert dismiss button"))))
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
        Text(NSLocalizedString("Ready to travel?", comment: "Welcome message"))
            .font(.largeTitle)
            .fontWeight(.bold)
            .foregroundColor(.white)
    }
    
    private var inputFields: some View {
        VStack(spacing: 20) {
            CustomTextField(text: $email, placeholder: NSLocalizedString("Email", comment: "Email field placeholder"), icon: "envelope")
            CustomTextField(text: $password, placeholder: NSLocalizedString("Password", comment: "Password field placeholder"), icon: "lock", isSecure: true)
        }
    }
    
    private var forgotPasswordButton: some View {
        Button(action: handleResetPassword) {
            Text(NSLocalizedString("Forgot Password?", comment: "Forgot password button"))
                .foregroundColor(.white)
                .font(.subheadline)
                .fontWeight(.semibold)
        }
    }
    
    private var signinButtons: some View {
        VStack(spacing: 15) {
            Button(action: signIn) {
                Text(NSLocalizedString("Sign In", comment: "Sign in button"))
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
            Text(NSLocalizedString("OR", comment: "Or divider text")).foregroundColor(.white).font(.caption)
            VStack { Divider().background(Color.white) }
        }
    }
    
    private var signupPrompt: some View {
        Text(NSLocalizedString("Don't have an account? Sign Up", comment: "Sign up prompt"))
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
            alertMessage = NSLocalizedString("Please enter a valid email address.", comment: "Invalid email error message")
            showAlert = true
        } else {
            Task {
                do {
                    try await authModel.resetPassword(email: email)
                    alertMessage = NSLocalizedString("Password reset email sent.", comment: "Password reset success message")
                    showAlert = true
                } catch {
                    alertMessage = NSLocalizedString("Failed to send password reset email, please try again.", comment: "Password reset failure message")
                    showAlert = true
                }
            }
        }
    }
    
    private func handleSignInError(_ error: Error) {
        switch (error as NSError).code {
        case 17004:
            alertMessage = NSLocalizedString("Incorrect email address or password, please try again", comment: "Incorrect credentials error message")
        case 17008:
            alertMessage = NSLocalizedString("The email is not in the correct format, please try again", comment: "Invalid email format error message")
        case 17009:
            alertMessage = NSLocalizedString("The email or the password is missing, please try again", comment: "Missing credentials error message")
        default:
            alertMessage = NSLocalizedString("Something went wrong, please try again", comment: "Generic error message")
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
                    .keyboardType(placeholder == NSLocalizedString("Email", comment: "Email field placeholder") ? .emailAddress : .default)
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
