//
//  QRView.swift
//  DaDaIkSeon
//
//  Created by 정재명 on 2020/11/26.
//

import SwiftUI
import CodeScanner

struct QRGuideView: View {
    
    // MARK: Property
    private(set) var service: TokenServiceable
    @State private var isShownScanner = false
    @State private var isShownEditView: Bool = false
    @Environment(\.presentationMode) private var mode: Binding<PresentationMode>
    
    @State private var qrCodeURL = ""
    
    // MARK: Body
    var body: some View {
        
        VStack {
            Spacer()
            Button(action: {
                isShownScanner = true
            }, label: {
                HStack {
                    Image(systemName: "camera.fill")
                    Text("QR 코드 스캔")
                }
                .foregroundColor(.black)
            })
            .frame(maxWidth: .infinity, maxHeight: 46)
            .background(Color(.systemGray6))
            .cornerRadius(15)
            
            NavigationLink(
                "",
                destination: NavigationLazyView(
                    TokenEditView(service: service,
                                  token: nil,
                                  qrCode: TOTPGenerator.extractKey(from: qrCodeURL))),
                isActive: $isShownEditView
            )
            .isDetailLink(false)
        }
        .padding(.horizontal, 40)
        .navigationBarHidden(false)
        .navigationBarTitle("QR 코드", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(
            leading: Button(action: {
                mode.wrappedValue.dismiss()
            }, label: {
                Text("취소").foregroundColor(.black)
            })
        )
        .sheet(isPresented: $isShownScanner) {
            QRScannerView(isShownEditView: $isShownEditView, qrCodeURL: $qrCodeURL)
        }
        
    }
}

struct QRScannerView: View {
    
    @Binding var isShownEditView: Bool
    @Binding var qrCodeURL: String
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var body: some View {
        VStack {
            CodeScannerView(codeTypes: [.qr], simulatedData: "-") { result in
                switch result {
                case .success(let url):
                    isShownEditView = true
                    qrCodeURL = url
                case .failure(let error):
                    print(error)
                }
                mode.wrappedValue.dismiss()
            }
        }
    }
    
}

// MARK: Preview

struct QRGuideView_Previews: PreviewProvider {
    static var previews: some View {
        QRGuideView(service: TokenService())
    }
}
