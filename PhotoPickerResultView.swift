import SwiftUI
import PhotosUI
import AVKit

struct PhotoPickerResultView: View {
    
    var result: PHPickerResult
    
    enum MediaType {
        case loading, error, video
    }
    

    @State private var loaded = false
    
    @State private var url: URL?
    

    @State private var mediaType: MediaType = .loading
    
    @State private var latestErrorDescription = ""
    
    var body: some View {
        Group {
            switch mediaType {
            case .loading:
                ProgressView()
            case .error:
                VStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                    Text(latestErrorDescription).font(.caption)
                }
                .foregroundColor(.gray)
            case .video:
                if url != nil {
                    VideoPlayer(player: AVPlayer(url: url!))
                } else {
                    EmptyView()
                }
            }
        }
        .onAppear {
            if !loaded {
                // load the object from the result
                loadObject()
            }
        }
        
    }
    
    func loadObject() {
        
        let itemProvider = result.itemProvider
        
        // make sure we have a valid typeIdentifier
        guard let typeIdentifier = itemProvider.registeredTypeIdentifiers.first,
              let _ = UTType(typeIdentifier)
        else {
            latestErrorDescription = "Could not find type identifier"
            mediaType = .error
            loaded = true
            return      
        }
    }
    
    
    
    private func getVideo(from itemProvider: NSItemProvider, typeIdentifier: String) {
        // get selected local video file url
        itemProvider.loadFileRepresentation(forTypeIdentifier: typeIdentifier) { url, error in
            // handle errors
            if let error = error {
                print(error.localizedDescription)
                latestErrorDescription = error.localizedDescription
                mediaType = .error
                loaded = true
            }
            
            // make sure url is not nil
            guard let url = url else {
                latestErrorDescription = "Url is nil"
                mediaType = .error
                loaded = true
                return
            }
            
            // get the documents directory
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            // create a target url where we will save our video
            guard let targetURL = documentsDirectory?.appendingPathComponent(url.lastPathComponent) else {
                latestErrorDescription = "Failed to create target url"
                mediaType = .error
                loaded = true
                return
            }
            
            do {
                // if the file alreay existe=s there remove it
                if FileManager.default.fileExists(atPath: targetURL.path) {
                    try FileManager.default.removeItem(at: targetURL)
                }
                
                // try to save the file
                try FileManager.default.copyItem(at: url, to: targetURL)
                
                DispatchQueue.main.async {
                    // set video so it appears on the view
                    self.mediaType = .video
                    self.url = targetURL
                    self.loaded = true
                }
            } catch {
                // handle errors
                print(error.localizedDescription)
                latestErrorDescription = error.localizedDescription
                mediaType = .error
                loaded = true
            }
        }
    }
    
    // remove all media, even deleting vidoes from url
    func delete() {
        switch mediaType {
        case .video:
            guard let url = url else { return }
            try? FileManager.default.removeItem(at: url)
            self.url = nil
        default:
            print("Default")
        }
    }
}
