Pod::Spec.new do |spec|
  spec.name         = "Paintinglite"
  spec.version      = "2.1.0"
  spec.source       = { :git => "https://github.com/CreaterOS/MTrack.git", :tag => "1.0" } 
  spec.source_files = "MTrack/**","MTrack/Element","MTrack/Source","MTrack/Source/Cache","MTrack/Source/Convert","MTrack/Source/Export","MTrack/Source/Meta","MTrack/Source/Model","MTrack/Source/Tail","MTrack/Source/Track",,"MTrack/Source/Vender"
  spec.summary      = "MTrack SDK"
  spec.homepage    = "https://github.com/CreaterOS/MTrack.git"
  spec.author       = {"CreaterOS" => "863713745@qq.com"}
  spec.platform     = :ios, "10.0"
end
