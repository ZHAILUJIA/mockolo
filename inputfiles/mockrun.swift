
    func mexecute(with arguments: ArgumentParser.Result) {
        let srcdirs = ["/Users/ellieshin/Developer/uber/ios/buck-out/gen/apps/iphone-helix/src/Uber/Rider/RiderCore/RiderMocks__srcs"]
        let exlist = ["Images", "Strings", "Model", "Models", "Service", "Service", "Fixtures",
                      "Test", "Tests", "Mock", "Mocks"]
        let output = "/Users/ellieshin/Developer/misc/mockolo/inputfiles/result.swift"
        let mockfile = "/Users/ellieshin/Developer/misc/mockolo/inputfiles/mockinputfile.txt"
        let text = try? String(contentsOfFile: mockfile, encoding: String.Encoding.utf8)
        let mockpaths = text?.components(separatedBy: " ")

        
               do {
                   try generate(sourceDirs: srcdirs,
                                sourceFiles: nil,
                                exclusionSuffixes: exlist,
                                mockFilePaths: mockpaths,
                                annotatedOnly: false,
                                annotation: "@CreateMock",
                                header: "",
                                macro: "",
                                to: output,
                                loggingLevel: 3,
                                concurrencyLimit: nil,
                                onCompletion: { _ in
                           log("Done. Exiting program.", level: .info)
                           exit(0)
                   })
               } catch {
                   fatalError("Generation error: \(error)")
               }
    }