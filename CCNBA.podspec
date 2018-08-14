#
#  Be sure to run `pod spec lint CCNBA.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "CCNBA"
  s.version      = "1.0.1"
  s.summary      = "CCNBA is a test"
  s.description  = <<-DESC
  "dfadsfasdfsadfdaf"
                   DESC
  s.homepage     = "https://github.com/wanccao/CCNBA.git"
  s.license      = "Apache License, Version 2.0"
  s.author             = { "wanchuanchao" => "wanchuanchao@github.com" }
  s.source       = { :git => "https://github.com/wanccao/CCNBA.git", :tag => "#{s.version}" }
  s.source_files  = "Classes/**/*.{h,m}"
end
