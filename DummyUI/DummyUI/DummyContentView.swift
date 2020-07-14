//
//  ContentView.swift
//  SpeculidDummy2
//
//  Created by Leo Dion on 7/14/20.
//

import SwiftUI

struct DummyContentView: View {
  @State var something: String = ""
  @State var removeAlpha : Bool = false
    @State var color: Color = .white
  
    var body: some View {
      
      Form{
        Section(header: Text("Source Graphic")){
        HStack{
          Spacer()
          Text("File Path:").frame(width: 150, alignment: .trailing)
          TextField("Something", text: self.$something)
            
            .overlay(Text("􀈖").foregroundColor(.primary).padding(.trailing, 4.0), alignment: .trailing)
            .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/).frame(width: 200)
          Text("􀎥")
          Spacer()
        }
        }
        Section(header: Text("Asset Catalog")){
          HStack{
            Spacer()
            Text("Folder:").frame(width: 150, alignment: .trailing)
            TextField("Something", text: self.$something)
              
              .overlay(Text("􀈖").foregroundColor(.primary).padding(.trailing, 4.0), alignment: .trailing)
              .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/).frame(width: 200)
            Text("􀎥")
            Spacer()
          }
          
            HStack{
              Spacer()
              Text("Contents.json:").frame(width: 150, alignment: .trailing)
              TextField("Something", text: self.$something)
                
                .overlay(Text("􀈖").foregroundColor(.primary).padding(.trailing, 4.0), alignment: .trailing)
                .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/).frame(width: 200)
              Text("􀎥")
              Spacer()
            }
        }
        Section(header: Text("App Icon Modifications")) {
            
            HStack{
                VStack(alignment: .leading){
                Toggle("Remove Alpha Channel", isOn: self.$removeAlpha)
                    
                    Text("If this is intended for an iOS, watchOS, or tvOS App,\nthen you should consider removing the alpha channel\nfrom the source graphic.").multilineTextAlignment(.leading).font(.subheadline).lineLimit(nil)
                }
              Spacer()
            }
            HStack{
                Toggle("Add a Background Color", isOn: self.$removeAlpha)
                ColorPicker("", selection: self.$color, supportsOpacity: false).labelsHidden().frame(width: 40, height: 25, alignment: .trailing)
                
            }
        }
 
      }
      .padding(.all)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
      DummyContentView().previewLayout(PreviewLayout.fixed(width: 400.0, height: 400.0))
    }
}
