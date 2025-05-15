import SwiftUI
import Network

// MARK: - View

struct NetworkObserverView: View {
    @Environment(\.networkMonitor) private var monitor
    
    var body: some View {
        List {
            Section("Status") {
                Text(monitor.isConnected ? "Connected" : "No Internet")
            }
            
            if let type = monitor.connectionType {
                Section("Type") {
                    Text(String(describing: type).capitalized)
                }
            }
        }
    }
}

// MARK: - Observable Network Monitor

@Observable
class NetworkMonitor {
    var isConnected: Bool = false
    var connectionType: NWInterface.InterfaceType? = nil
    
    @ObservationIgnored private let monitor = NWPathMonitor()
    @ObservationIgnored private let queue = DispatchQueue(label: "NetworkMonitorQueue")
    
    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            let newStatus = path.status == .satisfied
            let newType = [.wifi, .cellular, .wiredEthernet]
                .first(where: { path.usesInterfaceType($0) })
            
            DispatchQueue.main.async {
                if self?.isConnected != newStatus || self?.connectionType != newType {
                    self?.isConnected = newStatus
                    self?.connectionType = newType
                    print("Network Status Updated: \(newStatus), Type: \(String(describing: newType))")
                }
            }
        }
        monitor.start(queue: queue)
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
}

// MARK: - Environment Setup
private struct NetworkMonitorKey: EnvironmentKey {
    static let defaultValue = NetworkMonitor()
}

extension EnvironmentValues {
    var networkMonitor: NetworkMonitor {
        get { self[NetworkMonitorKey.self] }
        set { self[NetworkMonitorKey.self] = newValue }
    }
}

// MARK: - Preview

#Preview {
    NetworkObserverView()
}
