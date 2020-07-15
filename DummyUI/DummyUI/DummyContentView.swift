//
//  ContentView.swift
//  SpeculidDummy2
//
//  Created by Leo Dion on 7/14/20.
//

import SwiftUI
extension View {
    func tooltip(_ tip: String) -> some View {
        background(GeometryReader { childGeometry in
            TooltipView(tip, geometry: childGeometry) {
                self
            }
        })
    }
}

private struct TooltipView<Content>: View where Content: View {
    let content: () -> Content
    let tip: String
    let geometry: GeometryProxy

    init(_ tip: String, geometry: GeometryProxy, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.tip = tip
        self.geometry = geometry
    }

    var body: some View {
        Tooltip(tip, content: content)
            .frame(width: geometry.size.width, height: geometry.size.height)
    }
}

private struct Tooltip<Content: View>: NSViewRepresentable {
    typealias NSViewType = NSHostingView<Content>

    init(_ text: String?, @ViewBuilder content: () -> Content) {
        self.text = text
        self.content = content()
    }

    let text: String?
    let content: Content

    func makeNSView(context _: Context) -> NSHostingView<Content> {
        NSViewType(rootView: content)
    }

    func updateNSView(_ nsView: NSHostingView<Content>, context _: Context) {
        nsView.rootView = content
        nsView.toolTip = text
    }
}

protocol LabeledOption : RawRepresentable, Identifiable where RawValue == Int{
  static var mappedValues : [String] { get }
  var label: String { get }
  
  init (rawValue: RawValue, label : String)
}

extension LabeledOption {
  
  var id: Int {
    return self.rawValue
  }
  
  static func allValues () -> [Self] {
    self.mappedValues.enumerated().compactMap {
      Self.init(rawValue: $0.offset, label: $0.element)
    }
  }
  
  init?(rawValue: RawValue) {
    
    self.init(rawValue: rawValue, label: Self.mappedValues[rawValue])
  }
}

struct ResizeOption : LabeledOption {
  
  
  
  
  static let all = Self.allValues()
  
  let rawValue: Int
  
  static let mappedValues: [ String] =
    [ "None", "Width", "Height"]
  
  let label: String
  
  static let none = all[0]
  static let width = all[1]
  static let height = all[2]
}

struct DummyContentView: View {
  @State var geometryValue : Float = 0.0
  @State var something: String = ""
  @State var removeAlpha : Bool = false
    @State var color: Color = .white
  @State var resizeOption = ResizeOption.none.rawValue
  @State var addBackground: Bool = false
  
    var body: some View {      
      Form{
        Section(header: Text("Source Graphic")){
        HStack{
          Spacer()
          Text("File Path:").frame(width: 150, alignment: .trailing)
          TextField("SVG of PNG File", text: self.$something)
            
            .overlay(Text("􀈖").foregroundColor(.primary).padding(.trailing, 4.0), alignment: .trailing)
            .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/).frame(width: 200)
          Text("􀎥")
          Spacer()
        }
        }
        Divider()
        Section(header: Text("Asset Catalog")){
          HStack{
            Spacer()
            Text("Folder:").frame(width: 150, alignment: .trailing)
            TextField(".appiconset or .imageset", text: self.$something)
              
              .overlay(Text("􀈖").foregroundColor(.primary).padding(.trailing, 4.0), alignment: .trailing)
              .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/).frame(width: 200)
            Text("􀎥")
            Spacer()
          }
        }
        Divider()
        Section(header: Text("App Icon Modifications")) {
            
            HStack{
                VStack(alignment: .leading){
                Toggle("Remove Alpha Channel", isOn: self.$removeAlpha)
                    
                    Text("If this is intended for an iOS, watchOS, or tvOS App, then you should remove the alpha channel from the source graphic.").multilineTextAlignment(.leading).font(.subheadline).lineLimit(nil)
                }
              Spacer()
            }
          VStack(alignment: .leading){
            HStack{
                Toggle("Add a Background Color", isOn: self.$addBackground)
              ColorPicker("", selection: self.$color, supportsOpacity: false).labelsHidden().frame(width: 40, height: 25, alignment: .trailing).disabled(!self.addBackground).opacity(self.addBackground ? 1.0 : 0.5)
                
            }
            
            Text("If this is intended for an iOS, watchOS, or tvOS App, then you should set a background color.").multilineTextAlignment(.leading).font(.subheadline).lineLimit(nil)
          }
        }.disabled(true).opacity(0.5)
        Divider()
        Section(header: Text("Resizing Geometry")) {
          HStack{
            Picker("Resize", selection: self.$resizeOption) {
              ForEach(ResizeOption.all) {
                Text($0.label).tag($0.rawValue)
              }
            }.pickerStyle(SegmentedPickerStyle())
            .frame(width: 150, alignment: .leading).labelsHidden()
            TextField("Value", value: $geometryValue, formatter: NumberFormatter()).frame(width: 50, alignment: .leading).disabled(self.resizeOption == 0).opacity(self.resizeOption == 0 ? 0.5 : 1.0)
            Text("px").opacity(self.resizeOption == 0 ? 0.5 : 1.0)
          }
          Text("If you wish to render scaled PNG files for an image set, then specify either width or height and the image will be resized to that dimention while retaining its aspect ratio.\nOtherwise if you select \"None\", then only a PDF will be rendered.   ").multilineTextAlignment(.leading).font(.subheadline).lineLimit(nil)
        }
      }
      .padding(.all, 40.0).frame(minWidth: 500, idealWidth: 500, maxWidth: 600, minHeight: 500, idealHeight: 500, maxHeight: .infinity, alignment: .center)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
      DummyContentView().previewLayout(PreviewLayout.fixed(width: 500.0, height: 400.0))
    }
}
