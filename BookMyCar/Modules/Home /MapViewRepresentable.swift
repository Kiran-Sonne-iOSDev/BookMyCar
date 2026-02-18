//
//  MapViewRepresentable.swift
//  BookMyCar
//
//  Created by Kiran Sonne on 12/02/26.
//

import SwiftUI
import MapKit

struct MapViewRepresentable: UIViewRepresentable {
    
    @Binding var region: MKCoordinateRegion
    let pickupLocation: LocationEntity?
    let destinationLocation: LocationEntity?
    let route: RouteEntity?
    let car: TaxiCarEntity?
    
    // MARK: - Make UIView
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .none
        return mapView
    }
    
    // MARK: - Update UIView
    func updateUIView(_ mapView: MKMapView, context: Context) {
        // Update region
        mapView.setRegion(region, animated: true)
        
        // Remove existing annotations and overlays
        mapView.removeAnnotations(mapView.annotations.filter { !($0 is MKUserLocation) })
        mapView.removeOverlays(mapView.overlays)
        
        // Add pickup annotation
        if let pickup = pickupLocation {
            let annotation = MKPointAnnotation()
            annotation.coordinate = pickup.coordinate
            annotation.title = "Pickup"
            annotation.subtitle = pickup.title
            mapView.addAnnotation(annotation)
        }
        
        // Add destination annotation
        if let destination = destinationLocation {
            let annotation = MKPointAnnotation()
            annotation.coordinate = destination.coordinate
            annotation.title = "Destination"
            annotation.subtitle = destination.title
            mapView.addAnnotation(annotation)
        }
        
        // Add route overlay
        if let route = route {
            mapView.addOverlay(route.polyline)
        }
        
        // Add car annotation
        if let car = car {
            let carAnnotation = TaxiAnnotation(car: car)
            mapView.addAnnotation(carAnnotation)
        }
    }
    
    // MARK: - Make Coordinator
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    // MARK: - Coordinator
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapViewRepresentable
        
        init(_ parent: MapViewRepresentable) {
            self.parent = parent
        }
        
        // MARK: - Annotation View
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if annotation is MKUserLocation {
                return nil
            }
            
            // Handle Taxi Annotation
            if let taxiAnnotation = annotation as? TaxiAnnotation {
                let identifier = "TaxiAnnotation"
                var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
                
                if annotationView == nil {
                    annotationView = MKAnnotationView(annotation: taxiAnnotation, reuseIdentifier: identifier)
                    annotationView?.canShowCallout = false
                } else {
                    annotationView?.annotation = taxiAnnotation
                }
                
                // Create custom car image
                let carImage = createCarImage()
                annotationView?.image = carImage
                annotationView?.transform = CGAffineTransform(rotationAngle: taxiAnnotation.car.bearing * .pi / 180)
                
                return annotationView
            }
            
            // Handle regular annotations (pickup/destination)
            let identifier = "LocationAnnotation"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
            
            if annotationView == nil {
                annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
            } else {
                annotationView?.annotation = annotation
            }
            
            // Customize marker color
            if annotation.title == "Pickup" {
                annotationView?.markerTintColor = .green
                annotationView?.glyphImage = UIImage(systemName: "circle.fill")
            } else if annotation.title == "Destination" {
                annotationView?.markerTintColor = .red
                annotationView?.glyphImage = UIImage(systemName: "mappin.circle.fill")
            }
            
            return annotationView
        }
        
        // MARK: - Render Overlay (Route Line)
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = .systemBlue
                renderer.lineWidth = 4
                return renderer
            }
            return MKOverlayRenderer(overlay: overlay)
        }
        
        // MARK: - Create Car Image
        private func createCarImage() -> UIImage {
            let size = CGSize(width: 40, height: 40)
            let renderer = UIGraphicsImageRenderer(size: size)
            
            let image = renderer.image { context in
                // Draw car shape
                let carPath = UIBezierPath()
                
                // Car body
                carPath.move(to: CGPoint(x: 20, y: 10))
                carPath.addLine(to: CGPoint(x: 30, y: 15))
                carPath.addLine(to: CGPoint(x: 35, y: 25))
                carPath.addLine(to: CGPoint(x: 30, y: 35))
                carPath.addLine(to: CGPoint(x: 10, y: 35))
                carPath.addLine(to: CGPoint(x: 5, y: 25))
                carPath.addLine(to: CGPoint(x: 10, y: 15))
                carPath.close()
                
                UIColor.systemBlue.setFill()
                carPath.fill()
                
                UIColor.white.setStroke()
                carPath.lineWidth = 1
                carPath.stroke()
                
                // Windows
                let windowPath = UIBezierPath()
                windowPath.move(to: CGPoint(x: 15, y: 15))
                windowPath.addLine(to: CGPoint(x: 25, y: 15))
                windowPath.addLine(to: CGPoint(x: 25, y: 22))
                windowPath.addLine(to: CGPoint(x: 15, y: 22))
                windowPath.close()
                
                UIColor.systemCyan.withAlphaComponent(0.5).setFill()
                windowPath.fill()
            }
            
            return image
        }
    }
}

