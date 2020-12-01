//
//  TokenEditView.swift
//  DaDaIkSeon
//
//  Created by 정재명 on 2020/11/26.
//

import SwiftUI

struct TokenEditView: View {
    
    // MARK: Property
    
    @State var isEditing = false
    @State var text = ""
    @State private var segmentedMode = 0
    @State private var segmentList = ["색상", "아이콘"]
    @EnvironmentObject var navigationFlow: NavigationFlowObject
  
  // TokenEditview에 들어갈 아이들
  // var qrcode: String? // 추가 모드일 때
  // var token: Token? // 편집 모드일 때
  // var service: TokenService
    
    // MARK: Body
    
    var body: some View {
        
        VStack(spacing: 16) {
            
            Spacer()
            
            VStack(spacing: 32) {
                Image.search
                    .resizable()
                    .aspectRatio(1.0, contentMode: .fit)
                    .frame(minWidth: 70,
                           maxWidth: 80,
                           minHeight: 70,
                           maxHeight: 80)
                    .padding(45)
                    .background(LinearGradient.mint)
                    .foregroundColor(.white)
                    .cornerRadius(15)
                
                TextField("토큰 이름을 입력하세요", text: $text)
                    .padding(6)
                    .font(.system(size: 15))
                    .foregroundColor(.black)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .multilineTextAlignment(TextAlignment.center)
            }
            .padding(.horizontal, 90)
            
            Spacer()
            
            VStack(spacing: 40) {
                Picker("palette", selection: $segmentedMode) {
                    Text(segmentList[0]).tag(0)
                    Text(segmentList[1]).tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .onTapGesture {
                    segmentedMode = segmentedMode == 0 ? 1 : 0
                }
                
                segmentedMode == 0 ? PaletteView() : nil
                segmentedMode == 1 ? IconView() : nil
            }
            .padding(.horizontal, 40)
            
            Spacer()
            
            Button(action: {
                print("저장 버튼 Did Tap")
            }, label: {
                HStack {
                    Spacer()
                    Text("저장")
                        .foregroundColor(.white)
                    Spacer()
                }
            })
            .frame(width: 85)
            .padding(.vertical, 10)
            .background(LinearGradient.mint)
            .cornerRadius(15)
            
            Spacer()
        }
        .navigationBarHidden(false)
        .navigationBarTitle("토큰 추가", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(
            leading: Button(action: {
                navigationFlow.isActive = false
            }, label: {
                Text("취소").foregroundColor(.black)
            }),
            trailing: Button(action: {
                navigationFlow.isActive = false
            }, label: {
                Text("저장").foregroundColor(.black)
            })
        )
        .background(Color.white)
        .onTapGesture {
            hideKeyboard()
        }
    }
}

struct TokenEditView_Previews: PreviewProvider {
    static var previews: some View {
        TokenEditView()
    }
}
