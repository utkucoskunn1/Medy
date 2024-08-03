//
//  GetDrugInfoView.swift
//  Medy
//
//  Created by Utku on 01/08/24.
//

import SwiftUI

struct GetDrugInfoView: View {
    @State private var drugName: String = ""
    @State private var drugInfo: [String: [String]] = [:]
    @State private var isLoading: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter drug name", text: $drugName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button(action: {
                    fetchDrugInfo()
                }) {
                    Text("Get Drug Info")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .disabled(drugName.isEmpty)
                
                if isLoading {
                    ProgressView("Fetching drug info...")
                        .padding()
                } else {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 10) {
                            if !drugInfo.isEmpty {
                                
                            
                                if let purpose = drugInfo["Purpose"] {
                                    Group {
                                        Text("Purpose:")
                                            .font(.headline)
                                            .padding(.top)
                                        ForEach(purpose, id: \.self) { item in
                                            Text("• \(item)")
                                        }
                                    }
                                }
                                
                                if let sideEffects = drugInfo["Side effects"] {
                                    Group {
                                        Text("Side Effects:")
                                            .font(.headline)
                                            .padding(.top)
                                        ForEach(sideEffects, id: \.self) { item in
                                            Text("• \(item)")
                                        }
                                    }
                                }
                                
                                if let company = drugInfo["Company"] {
                                    Group {
                                        Text("Company:")
                                            .font(.headline)
                                            .padding(.top)
                                        ForEach(company, id: \.self) { item in
                                            Text("• \(item)")
                                        }
                                    }
                                }
                                
                                if let year = drugInfo["Year of approval"] {
                                    Group {
                                        Text("Year of Approval:")
                                            .font(.headline)
                                            .padding(.top)
                                        ForEach(year, id: \.self) { item in
                                            Text("• \(item)")
                                        }
                                    }
                                }
                                
                                if let storage = drugInfo["Storage conditions"] {
                                    Group {
                                        Text("Storage Conditions:")
                                            .font(.headline)
                                            .padding(.top)
                                        ForEach(storage, id: \.self) { item in
                                            Text("• \(item)")
                                        }
                                    }
                                }
                                
                                if let year = drugInfo["Country of Origin"] {
                                    Group {
                                        Text("Country of Origin:")
                                            .font(.headline)
                                            .padding(.top)
                                        ForEach(year, id: \.self) { item in
                                            Text("• \(item)")
                                        }
                                    }
                                }
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                
                Spacer()
                
                Text("Warning:")
                    .font(.headline)
                    .padding(.top)
                Text("This information is for general informational purposes and has been compiled from internet searches. For accurate and reliable medical information, please consult your doctor or healthcare professionals.")
                    .font(.footnote)
                    .padding()
                    .cornerRadius(8)
                    
                                        
            }
            .padding()
            .navigationTitle("Get Drug Info")
        }
    }
    
    func fetchDrugInfo() {
        guard !drugName.isEmpty else { return }
        isLoading = true
        
        let apiKey = fetchAPIKey()
        let url = URL(string: "https://api.openai.com/v1/chat/completions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let messages: [[String: String]] = [
            ["role": "user", "content": """
            You are a medical assistant. Provide detailed and accurate information about the drug \(drugName) in short bullet points with 4-5 words max. Ensure the information includes:
            - Purpose
            - Side effects
            - Company
            - Year of approval
            - Storage conditions
            - Country of Origin
            Provide the information concisely and ensure it is medically accurate.
            """]
        ]
        
        let parameters: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": messages,
            "max_tokens": 150,
            "temperature": 0.7
        ]
        
        let data = try! JSONSerialization.data(withJSONObject: parameters, options: [])
        request.httpBody = data
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            defer { isLoading = false }
            
            if let error = error {
                DispatchQueue.main.async {
                    self.drugInfo = ["Error": ["Failed to fetch drug info: \(error.localizedDescription)"]]
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    self.drugInfo = ["Error": ["Failed to fetch drug info: No data received."]]
                }
                return
            }
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Response JSON: \(jsonString)")
            }
            
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let choices = json["choices"] as? [[String: Any]],
               let message = choices.first?["message"] as? [String: Any],
               let text = message["content"] as? String {
                DispatchQueue.main.async {
                    self.drugInfo = self.parseDrugInfo(text)
                }
            } else {
                DispatchQueue.main.async {
                    self.drugInfo = ["Error": ["No information found for \(drugName)."]]
                }
            }
        }
        
        task.resume()
    }
    
    func fetchAPIKey() -> String {
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
              let xml = FileManager.default.contents(atPath: path),
              let config = try? PropertyListSerialization.propertyList(from: xml, options: .mutableContainersAndLeaves, format: nil) as? [String: Any],
              let apiKey = config["OpenAI_API_Key"] as? String else {
            return ""
        }
        return apiKey
    }
    
    func parseDrugInfo(_ text: String) -> [String: [String]] {
        var info: [String: [String]] = [:]
        
        let lines = text.split(separator: "\n")
        for line in lines {
            if line.starts(with: "- ") {
                let parts = line.split(separator: ":", maxSplits: 1)
                if parts.count == 2 {
                    let sectionName = parts[0].replacingOccurrences(of: "- ", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
                    let sectionContent = parts[1].trimmingCharacters(in: .whitespacesAndNewlines)
                    if info[sectionName] != nil {
                        info[sectionName]?.append(sectionContent)
                    } else {
                        info[sectionName] = [sectionContent]
                    }
                }
            }
        }
        
        return info
    }
}

struct GetDrugInfoView_Previews: PreviewProvider {
    static var previews: some View {
        GetDrugInfoView()
    }
}
