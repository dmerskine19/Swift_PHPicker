import SwiftUI
import Photos
import PhotosUI
import Combine

class PhotoPickerService: ObservableObject {
    
    
    @Published var isPresented = false
    @Published var results = [PHPickerResult]()
    @Published var filters: [PHPickerFilter] = []
    @Published var selectionLimit: PhotoPickerSelectionLimit = 1
    
    // preset the PhotoPicker with optional filters and selection limit
    func present(filters: [PHPickerFilter] = [.images], selectionLimit: PhotoPickerSelectionLimit = 1) {
        self.filters = filters
        self.selectionLimit = selectionLimit
        isPresented = true
    }
    
    // resets the PhotoPickerService to defaults
    func reset() {
        filters.removeAll()
        selectionLimit = .exactly(1)
    }
    
    // removes all media from the results
    func removeAll() {
        results.removeAll()
    }
}
