//
//  ProfileView.swift
//  LearningToBudget
//
//  Created by Christian Grise on 3/24/25.
//

import SwiftUI

struct ProfileView: View {
    // Using new environment binding
    @Environment(UserManager.self) private var userManager
    
    @State private var user: User
    @State private var isEditMode = false
    @State private var editedName: String = ""
    @State private var editedEmail: String = ""
    
    @State private var isShowingImagePicker = false
    @State private var inputImage: UIImage?

    init(user: User) {
        _user = State(initialValue: user)
        _editedName = State(initialValue: user.name)
        _editedEmail = State(initialValue: user.email)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Profile Image Section
                VStack {
                    if let profileImage = user.profileImage {
                        Image(uiImage: UIImage(data: profileImage) ?? UIImage())
                            .resizable()
                            .scaledToFill()
                            .frame(width: 200, height: 200)
                            .clipShape(Circle())
                            .overlay(
                                Circle().stroke(Color.gray.opacity(0.3), lineWidth: 2)
                            )
                            .onTapGesture {
                                isShowingImagePicker = true
                            }
                    } else {
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.gray)
                            .frame(width: 100, height: 100)
                            .onTapGesture {
                                isShowingImagePicker = true
                            }
                    }
                }
                .padding(.vertical, 20)
                
                Form {
                    Section(header: Text("Basic Information")) {
                        if isEditMode {
                            // Editable Fields
                            TextField("Name", text: $editedName)
                            TextField("Email", text: $editedEmail)
                            
                            // Optional: Date of Creation (usually not editable)
                            Text("Account created: \(formattedDate(user.creationDate))")
                        } else {
                            // Read-only Fields
                            LabeledContent("Name", value: user.name)
                            LabeledContent("Email", value: user.email)
                            LabeledContent("Account created", value: formattedDate(user.creationDate))
                        }
                    }
                }
            }
            .navigationTitle("User Profile")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(isEditMode ? "Save" : "Edit") {
                        if isEditMode {
                            // Save changes
                            user.name = editedName
                            user.email = editedEmail
                            saveUserChanges()
                        } else {
                            // Prepare for editing
                            editedName = user.name
                            editedEmail = user.email
                        }
                        isEditMode.toggle()
                    }
                }
            }
            .sheet(isPresented: $isShowingImagePicker) {
                ImagePicker(image: $inputImage)
            }
            .onChange(of: inputImage) {
                loadImage()
            }
        }
    }
    
    func saveUserChanges() {
        // Implement your save logic here
        // This might involve calling a method on your UserManager
        // or updating a database/network service
        print("Saving user changes: \(editedName), \(editedEmail)")
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    private func loadImage() {
        guard let inputImage = inputImage else { return }
        if let imageData = inputImage.jpegData(compressionQuality: 0.8) {
            user.profileImage = imageData
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.image = image
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}


#Preview {
    ProfileView(user: .example)
        .environment(UserManager())
}
