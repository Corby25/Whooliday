import SwiftUI
import Firebase
import GoogleSignInSwift

// view for the signin page
struct SigninView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showingSignup = false
    @EnvironmentObject var authModel: AuthModel
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                logoView
                welcomeText
                inputFields
                signinButtons
                forgotPasswordButton
                signupPrompt
            }
            .padding(.horizontal, 30)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemBackground))
            .navigationBarHidden(true)
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"),
                      message: Text(alertMessage),
                      dismissButton: .default(Text("OK")))
            }
        }
    }
    
    private var logoView: some View {
        Image("logosmall")
            .resizable()
            .scaledToFit()
            .frame(width: 80, height: 80)
            .padding(.top, 50)
    }
    
    private var welcomeText: some View {
        Text("Welcome back")
            .font(.largeTitle)
            .fontWeight(.bold)
            .foregroundColor(.primary)
    }
    
    private var inputFields: some View {
        VStack(spacing: 20) {
            CustomTextField(text: $email, placeholder: "Email", icon: "envelope")
            CustomTextField(text: $password, placeholder: "Password", icon: "lock", isSecure: true)
        }
    }
    
    // buttons for the normal signin and the one with Google
    private var signinButtons: some View {
        VStack(spacing: 15) {
            Button(action: signIn) {
                Text("Sign In")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            
            GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(scheme: .light, style: .wide, state: .normal)) {
                Task {
                    do {
                        try await authModel.signInGoogle()
                    } catch {
                        handleSignInError(error)
                    }
                }
            }
        
            .frame(width: 200)
            .clipShape(RoundedRectangle(cornerRadius: 10))            
        }
    }
    
    private var forgotPasswordButton: some View {
        Button(action: handleResetPassword) {
            Text("Forgot Password?")
                .foregroundColor(.blue)
                .font(.subheadline)
                .padding(.bottom, 50)
        }
    }
    
    // link to the signup page
    private var signupPrompt: some View {
        HStack {
            Text(NSLocalizedString("Don't have an account?", comment: ""))
                .foregroundColor(.gray)
            NavigationLink(destination: SignupView()) {
                Text("Sign Up")
                    .foregroundColor(.blue)
                    .fontWeight(.semibold)
            }
        }
        .font(.subheadline)
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
            alertMessage = NSLocalizedString("Please enter a valid email address.", comment: "")
            showAlert = true
        } else {
            Task {
                do {
                    try await authModel.resetPassword(email: email)
                    alertMessage = NSLocalizedString("Password reset email sent.", comment: "")
                    showAlert = true
                } catch {
                    alertMessage = NSLocalizedString("Failed to send password reset email, please try again.", comment: "")
                    showAlert = true
                }
            }
        }
    }
    
    // different alert messages for different types of errors
    private func handleSignInError(_ error: Error) {
        let errorMessage: String
        switch (error as NSError).code {
        case 17004:
            errorMessage = NSLocalizedString("Incorrect email address or password, please try again", comment: "")
        case 17008:
            errorMessage = NSLocalizedString("The email is not in the correct format, please try again", comment: "")
        case 17009:
            errorMessage = NSLocalizedString("The email or the password is missing, please try again", comment: "")
        default:
            errorMessage = NSLocalizedString("Something went wrong, please try again", comment: "")
        }
        alertMessage = errorMessage
        showAlert = true
        password = ""
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegEx).evaluate(with: email)
    }
}

struct CustomTextField: View {
    @Binding var text: String
    let placeholder: String
    let icon: String
    var isSecure: Bool = false
    
    var body: some View {
        HStack {
            Image(systemName: icon).foregroundColor(.gray)
            if isSecure {
                SecureField(placeholder, text: $text)
            } else {
                TextField(placeholder, text: $text)
                    .keyboardType(placeholder == "Email" ? .emailAddress : .default)
                    .autocapitalization(.none)
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct SigninView_Previews: PreviewProvider {
    static var previews: some View {
        SigninView().environmentObject(AuthModel())
    }
}
