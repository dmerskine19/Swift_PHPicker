import SwiftUI
import PhotosUI


struct PhotoPicker: UIViewControllerRepresentable {
    typealias UIViewControllerType = PHPickerViewController
    
    @ObservedObject var service: PhotoPickerService
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .any(of: service.filters)
        config.selectionLimit = service.selectionLimit
        config.preferredAssetRepresentationMode = .current
        
        let controller = PHPickerViewController(configuration: config)
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(with: self)
    }
    
    
    class Coordinator: PHPickerViewControllerDelegate {
        var photoPicker: PhotoPicker
        
        init(with photoPicker: PhotoPicker) {
            self.photoPicker = photoPicker
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            photoPicker.service.isPresented = false
            
            guard !results.isEmpty else {
                return
            }
            
            photoPicker.service.results = results
        }
        
    }
}
