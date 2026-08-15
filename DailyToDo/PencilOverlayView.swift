//
//  PencilOverlayView.swift
//  DailyToDo
//
//  Created by Amy Rowell on 8/13/26.
//

import SwiftUI
import PencilKit

private final class ResizableCanvasView: PKCanvasView {
    var onResize: ((CGSize, CGSize) -> Void)?
    private var lastSize: CGSize = .zero
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let newSize = bounds.size
        if lastSize != .zero, newSize != .zero, lastSize != newSize {
            onResize?(lastSize, newSize)
        }
        lastSize = newSize
    }
}


struct PencilOverlayView: UIViewRepresentable {
    @Binding var drawingData: Data
    var isDrawMode: Bool
    
    func makeUIView(context: Context) -> PKCanvasView {
        
        let canvas = ResizableCanvasView()
        canvas.backgroundColor = .clear
        canvas.isOpaque = false
        canvas.drawingPolicy = .pencilOnly
        canvas.tool = PKInkingTool(.pen, color: .label, width: 3)
        canvas.delegate = context.coordinator
        canvas.isScrollEnabled = false
        canvas.isUserInteractionEnabled = isDrawMode
        
        if !drawingData.isEmpty, let drawing = try?
            PKDrawing(data: drawingData){
            canvas.drawing = drawing
        }
        context.coordinator.lastKnownData = drawingData
        
        
        canvas.onResize = { [weak canvas] oldSize, newSize in
            guard let canvas, oldSize.width > 0,
                  oldSize.height > 0 else { return }
            let scaleX = newSize.width / oldSize.width
            let scaleY = newSize.height / oldSize.height
            let transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
            canvas.drawing = canvas.drawing.transformed(using: transform)
            let data = canvas.drawing.dataRepresentation()
            context.coordinator.parent.drawingData = data
            context.coordinator.lastKnownData = data
                          
        }
        
        let toolPicker = PKToolPicker()
        toolPicker.addObserver(canvas)
        context.coordinator.toolPicker = toolPicker
        
        return canvas
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        
        uiView.isUserInteractionEnabled = isDrawMode
        
        if drawingData != context.coordinator.lastKnownData {
            if drawingData.isEmpty {
                uiView.drawing = PKDrawing()
            } else if let drawing = try? PKDrawing(data: drawingData) {
                uiView.drawing = drawing
            }
            context.coordinator.lastKnownData = drawingData
        }
        
        guard let toolPicker = context.coordinator.toolPicker else
{ return }
    
    if isDrawMode {
        toolPicker.setVisible(true, forFirstResponder: uiView)
        DispatchQueue.main.async {
            uiView.becomeFirstResponder()
        }
    } else {
        toolPicker.setVisible(false, forFirstResponder: uiView)
        uiView.resignFirstResponder()
    }
}
    
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, PKCanvasViewDelegate {
        var parent: PencilOverlayView
        var toolPicker: PKToolPicker?
        var lastKnownData: Data = Data()
        private var pendingSave: DispatchWorkItem?
        
        init(_ parent: PencilOverlayView) {
            self.parent = parent
        }
        
        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            pendingSave?.cancel()
            let data = canvasView.drawing.dataRepresentation()
            let workItem = DispatchWorkItem { [weak self] in
                self?.lastKnownData = data
                self?.parent.drawingData = data
                
        }
            pendingSave = workItem
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: workItem)
        }
    }
}
