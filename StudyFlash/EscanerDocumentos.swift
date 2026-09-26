//
//  EscanerDocumentos.swift
//  StudyFlash
//
//  Created by Omar Martinez Lopez on 26/09/26.
//

import SwiftUI
import VisionKit
import Vision

struct EscanerDocumentos: UIViewControllerRepresentable{
    var alTerminar: (String) -> Void
    
    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let controlador = VNDocumentCameraViewController()
        controlador.delegate = context.coordinator
        return controlador
    }
    
    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(alTerminar: alTerminar)
    }
}

class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate{
    let alTerminar: (String) -> Void
    
    init(alTerminar: @escaping (String) -> Void){
        self.alTerminar = alTerminar
    }
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        var textoCompleto = ""
        
        Task{
            for pagina in 0..<scan.pageCount{
                let imagen = scan.imageOfPage(at: pagina)
                if let texto = await reconocerTexto(en: imagen){
                    textoCompleto += texto + "\n"
                }
            }
            alTerminar(textoCompleto)
            controller.dismiss(animated: true)
            
        }
    }
    
    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        controller.dismiss(animated: true)
    }
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
        controller.dismiss(animated: true)
    }
    
    func reconocerTexto(en imagen: UIImage) async -> String? {
        guard let cgImage = imagen.cgImage else{return nil}
        return await withCheckedContinuation{Continuation in
            let solicitud = VNRecognizeTextRequest{request, _ in
                let observaciones = request.results as? [VNRecognizedTextObservation] ?? []
                let texto = observaciones.compactMap{$0.topCandidates(1).first?.string}.joined(separator: "\n")
                Continuation.resume(returning:texto)
            }
            
            solicitud.recognitionLanguages = ["es-MX", "en-US"]
            solicitud.recognitionLevel = .accurate
            
            let manejador = VNImageRequestHandler(cgImage: cgImage, options: [:])
            try? manejador.perform([solicitud])
        }
    }
}
