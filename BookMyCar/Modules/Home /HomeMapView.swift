//
//  HomeMapView.swift
//  BookMyCar
//
//  Created by Kiran Sonne on 12/02/26.
//

import SwiftUI
import MapKit

struct HomeMapView: UIViewRepresentable {
    
    @Binding var region: MKCoordinateRegion
    let nearbyCars: [TaxiCarEntity]
    let selectedRoute: RouteEntity?
    let pickupLocation: LocationEntity?
    let destinationLocation: LocationEntity?
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = false
        mapView.isRotateEnabled = true
        mapView.isZoomEnabled = true
        mapView.isPitchEnabled = false
        
        // Remove default map elements for cleaner look
        mapView.showsCompass = false
        mapView.showsScale = false
        
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        mapView.setRegion(region, animated: true)
        
        // Remove existing annotations
        mapView.removeAnnotations(mapView.annotations)
        
        // Add taxi car annotations
        for car in nearbyCars {
            let annotation = TaxiAnnotation(car: car)
            mapView.addAnnotation(annotation)
        }
        
        // Remove existing overlays
        mapView.removeOverlays(mapView.overlays)
        
        // Add route overlays if available
        if let route = selectedRoute {
            mapView.addOverlay(route.polyline)
        }
        // Add pickup marker
        if let pickup = pickupLocation {
            let annotation = MKPointAnnotation()
            annotation.coordinate = pickup.coordinate
            annotation.title = "Pickup"
            mapView.addAnnotation(annotation)
        }

        // Add destination marker
        if let destination = destinationLocation {
            let annotation = MKPointAnnotation()
            annotation.coordinate = destination.coordinate
            annotation.title = "Destination"
            mapView.addAnnotation(annotation)
        }

    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    // MARK: - Coordinator
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: HomeMapView
        
        init(_ parent: HomeMapView) {
            self.parent = parent
        }
        
        // MARK: - Annotation View
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard let taxiAnnotation = annotation as? TaxiAnnotation else {
                return nil
            }
            
            let identifier = "TaxiAnnotation"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: taxiAnnotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = false
            } else {
                annotationView?.annotation = taxiAnnotation
            }
            
            // Create yellow taxi image
            let taxiImage = createYellowTaxiImage()
            annotationView?.image = taxiImage
            
            // Rotate based on bearing
            let rotation = CGAffineTransform(rotationAngle: taxiAnnotation.car.bearing * .pi / 180)
            annotationView?.transform = rotation
            
            return annotationView
        }
        
        // MARK: - Render Overlay (Curved Route)
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                
                // Create gradient effect (yellow to orange)
                renderer.strokeColor = UIColor(red: 1.0, green: 0.84, blue: 0.0, alpha: 1.0)
                renderer.lineWidth = 5
                renderer.lineCap = .round
                renderer.lineJoin = .round
                
                return renderer
            }
            return MKOverlayRenderer(overlay: overlay)
        }
        
        // MARK: - Create Yellow Taxi Image
        private func createYellowTaxiImage() -> UIImage {
            let size = CGSize(width: 50, height: 50)
            let renderer = UIGraphicsImageRenderer(size: size)
            
            let image = renderer.image { context in
                let ctx = context.cgContext
                
                // Draw taxi body (yellow)
                let taxiBody = UIBezierPath()
                
                // Main body
                taxiBody.move(to: CGPoint(x: 25, y: 12))
                taxiBody.addLine(to: CGPoint(x: 35, y: 18))
                taxiBody.addLine(to: CGPoint(x: 42, y: 30))
                taxiBody.addCurve(to: CGPoint(x: 40, y: 40),
                                  controlPoint1: CGPoint(x: 43, y: 33),
                                  controlPoint2: CGPoint(x: 42, y: 37))
                taxiBody.addLine(to: CGPoint(x: 10, y: 40))
                taxiBody.addCurve(to: CGPoint(x: 8, y: 30),
                                  controlPoint1: CGPoint(x: 8, y: 37),
                                  controlPoint2: CGPoint(x: 7, y: 33))
                taxiBody.addLine(to: CGPoint(x: 15, y: 18))
                taxiBody.close()
                
                // Fill with yellow
                UIColor(red: 1.0, green: 0.84, blue: 0.0, alpha: 1.0).setFill()
                taxiBody.fill()
                
                // Add black stripes
                ctx.setStrokeColor(UIColor.black.cgColor)
                ctx.setLineWidth(3)
                
                // Stripe 1
                ctx.move(to: CGPoint(x: 18, y: 22))
                ctx.addLine(to: CGPoint(x: 22, y: 30))
                ctx.strokePath()
                
                // Stripe 2
                ctx.move(to: CGPoint(x: 28, y: 22))
                ctx.addLine(to: CGPoint(x: 32, y: 30))
                ctx.strokePath()
                
                // Windows (light blue)
                let windowPath = UIBezierPath()
                windowPath.move(to: CGPoint(x: 20, y: 18))
                windowPath.addLine(to: CGPoint(x: 30, y: 18))
                windowPath.addLine(to: CGPoint(x: 30, y: 25))
                windowPath.addLine(to: CGPoint(x: 20, y: 25))
                windowPath.close()
                
                UIColor(red: 0.7, green: 0.9, blue: 1.0, alpha: 0.6).setFill()
                windowPath.fill()
                
                // Outline
                UIColor.black.setStroke()
                taxiBody.lineWidth = 1.5
                taxiBody.stroke()
                
                // Wheels (small black circles)
                let wheel1 = UIBezierPath(ovalIn: CGRect(x: 12, y: 38, width: 6, height: 6))
                let wheel2 = UIBezierPath(ovalIn: CGRect(x: 32, y: 38, width: 6, height: 6))
                
                UIColor.black.setFill()
                wheel1.fill()
                wheel2.fill()
            }
            
            return image
        }
    }
}

// MARK: - Taxi Annotation
class TaxiAnnotation: NSObject, MKAnnotation {
    let car: TaxiCarEntity
    
    var coordinate: CLLocationCoordinate2D {
        car.coordinate
    }
    
    var title: String? {
        car.driverName
    }
    
    var subtitle: String? {
        car.carNumber
    }
    
    init(car: TaxiCarEntity) {
        self.car = car
        super.init()
    }
}

