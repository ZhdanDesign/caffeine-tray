import Foundation

final class CaffeinateService {
    private var process: Process?

    var isRunning: Bool {
        guard let process else { return false }
        return process.isRunning
    }

    func start(for seconds: TimeInterval) throws {
        stop()

        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/caffeinate")
        process.arguments = ["-dimsu", "-t", String(Int(seconds.rounded()))]
        try process.run()
        self.process = process
    }

    func stop() {
        guard let process else { return }
        if process.isRunning {
            process.terminate()
        }
        self.process = nil
    }
}
