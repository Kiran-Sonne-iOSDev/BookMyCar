//
//  HomeView.swift
//  BookMyCar
//
//  Created by Kiran Sonne on 07/02/26.
//

// HomeView.swift
import SwiftUI
import MapKit

struct HomeView: View {
    
    @StateObject var presenter: HomePresenter
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 19.9975, longitude: 73.7898),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @State private var showSideMenu = false
    
    var body: some View {
        ZStack {
            // Map View
            Map(coordinateRegion: $region, annotationItems: presenter.vehicles) { vehicle in
                MapAnnotation(coordinate: CLLocationCoordinate2D(
                    latitude: vehicle.latitude,
                    longitude: vehicle.longitude
                )) {
                    VehicleMarker()
                }
            }
            .edgesIgnoringSafeArea(.all)
            
            // Top Menu Button
            VStack {
                HStack {
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showSideMenu.toggle()
                        }
                    }) {
                        Image(systemName: "line.3.horizontal")
                            .font(.system(size: 24, weight: .medium))
                            .foregroundColor(.black)
                            .frame(width: 50, height: 50)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                    }
                    .padding(.leading, 20)
                    .padding(.top, 50)
                    
                    Spacer()
                }
                
                Spacer()
            }
            
            // Bottom Sheet
            VStack {
                Spacer()
                
                VStack(spacing: 0) {
                    // Pickup Location
                    HStack {
                        Image(systemName: "car.fill")
                            .foregroundColor(.black)
                            .font(.title3)
                        
                        Text(presenter.pickupLocation)
                            .font(.body)
                            .foregroundColor(.black)
                        
                        Spacer()
                    }
                    .padding()
                    .background(Color.white)
                    
                    // Vehicle Type Selection
                    HStack(spacing: 20) {
                        ForEach(VehicleType.allCases, id: \.self) { type in
                            VehicleTypeButton(
                                type: type,
                                isSelected: presenter.selectedVehicleType == type,
                                time: type == .economy ? presenter.estimatedTime : "To scan",
                                action: {
                                    presenter.selectVehicleType(type)
                                }
                            )
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 20)
                    .background(Color.white)
                    // Book Button
                    Button(action: {
                        presenter.bookRide()
                    }) {
                        Text("Book Car")
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.yellow)
                            .cornerRadius(25)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 30)
                    .background(Color.white)
                }
                .background(Color.white)
                .cornerRadius(30, corners: [.topLeft, .topRight])
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: -5)
            }
            
            // Side Menu Overlay
            SideMenuView(isShowing: $showSideMenu)
        }
        .onAppear {
            presenter.onViewAppear()
        }
    }
}

// MARK: - Supporting Views
struct VehicleMarker: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.yellow)
                .frame(width: 40, height: 40)
            
            Image(systemName: "car.fill")
                .foregroundColor(.black)
                .font(.system(size: 20))
                .rotationEffect(.degrees(45))
        }
    }
}

struct VehicleTypeButton: View {
    let type: VehicleType
    let isSelected: Bool
    let time: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text(type.rawValue)
                    .font(.caption)
                    .fontWeight(isSelected ? .bold : .regular)
                
                Text(time)
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(isSelected ? Color.yellow.opacity(0.3) : Color.gray.opacity(0.1))
            .cornerRadius(10)
        }
        .foregroundColor(.black)
    }
}

// Helper for rounded corners
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

// MARK: - Preview
#Preview {
    HomeBuilder.build()
}
