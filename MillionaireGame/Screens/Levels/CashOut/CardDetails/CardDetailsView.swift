import SwiftUI
import DesignSystem

struct CardDetailsView: View {
    
    @State private var fullName: String = ""
    @State private var email: String = ""
    @State private var phoneNumber: String = ""
    @State private var location: String = ""
    @State private var cardNumber: String = ""
    @State private var cardHolderName: String = ""
    @State private var expiryDate: String = ""
    @State private var cvv: String = ""
    
    @State private var showAlert: Bool = false
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Personal Information")) {
                    TextField("Full Name", text: $fullName)
                        .textInputAutocapitalization(.words)
                    
                    TextField("Email Address", text: $email)
                        .keyboardType(.emailAddress)
                    
                    TextField("Phone Number", text: $phoneNumber)
                        .keyboardType(.phonePad)
                    
                    TextField("Location", text: $location)
                        .textInputAutocapitalization(.words)
                }
                
                Section(header: Text("Card Information")) {
                    TextField("Card Number", text: $cardNumber)
                        .keyboardType(.numberPad)
                    
                    TextField("Cardholder Name", text: $cardHolderName)
                        .textInputAutocapitalization(.words)
                    
                    HStack {
                        TextField("MM/YY", text: $expiryDate)
                            .keyboardType(.numbersAndPunctuation)
                        
                        TextField("CVV", text: $cvv)
                            .keyboardType(.numberPad)
                            .frame(width: 80)
                    }
                }
                
                Section {
                    Button(action: handleWithdraw) {
                        Text("Request Withdrawal")
                            .frame(maxWidth: .infinity)
                    }
                }
            }
            .navigationTitle("Withdraw Winnings")
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Withdrawal Request"),
                      message: Text("Successful withdrawal request, please wait for our response"),
                      dismissButton: .default(Text("Done")))
            }
            
        }
    }
    
    func handleWithdraw() {
        showAlert = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            dismiss()
        }
    }
}
