import SwiftUI
import PDFKit

struct Instruction : View {
    var body: some View {
        PDFKitView(pdfName: "instruction")
            .navigationTitle("Experiment Manual")
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct PDFKitView: UIViewRepresentable {
    let pdfName: String
    
    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        if let url = Bundle.main.url(forResource: pdfName, withExtension: "pdf"),
           let document = PDFDocument(url: url) {
            pdfView.document = document
            pdfView.autoScales = true
        } else {
            print("⚠️ Could not load PDF named \(pdfName).pdf")
        }
        return pdfView
    }
    
    func updateUIView(_ uiView: PDFView, context: Context) {
        // Nothing needed here
    }
}
