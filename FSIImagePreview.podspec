Pod::Spec.new do |s|

  s.name         = "FSIImagePreview"
  s.version      = "0.0.1"
  s.summary      = "A lighweight framework for opening images in fullscreen mode."
  s.homepage     = "https://github.com/vladislavitsi/FSIImagePreview"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Uladzislau Kleshchanka" => "vladislavitsi@gmail.com" }
  s.platform     = :ios, "10.0"
  s.source       = { :git => "https://github.com/vladislavitsi/FSIImagePreview.git", :tag => "0.0.1" }
  s.source_files = 'FSIImagePreview/**/*.{swift, h, m}'
  s.swift_version = '4.0'

end
