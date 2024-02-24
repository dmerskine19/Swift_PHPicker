import SwiftUI
import PhotosUI

struct ContentView: View {
    
    @StateObject var photoPickerService = PhotoPickerService()
    
    var body: some View {
        VStack {
            if photoPickerService.results.count == 0 {
            } else {
                ScrollView {
                    ForEach(photoPickerService.results, id: \.self) { result in
                        PhotoPickerResultView(result: result)
                            .scaledToFill()
                            .frame(maxWidth: .infinity, minHeight: 200, idealHeight: 200)
                            .clipped()
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button {
                    photoPickerService.removeAll()
                } label: {
                    Image(systemName: "trash")
                }
                .buttonStyle(.bordered)
            }
            ToolbarItem(placement: .primaryAction) {
                VStack {
                    HStack {
                        Button {
                            photoPickerService.present(filters: [.videos], selectionLimit: .exactly(1))
                        } label: {
                            Image(systemName: "play.rectangle")
                        }
                        
                    }
                }
            }
        }

        .sheet(isPresented: $photoPickerService.isPresented) {
            PhotoPicker(service: photoPickerService)
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
